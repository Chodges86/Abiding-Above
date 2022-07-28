//
//  BibleModel.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 11/4/21.
//

import Foundation
import UIKit

protocol VerseDelegate {
    func verseReceived(verse: String, copyright: String)
    func errorReceivingVerse(error: String?)
}

enum BibleVersion: String, CaseIterable {
    case NLT
    case NASB
    case NIV
}

struct BibleModel {
    
    var delegate: VerseDelegate?
    
    let apiKey = K.BibleConstants.apiKey
    
    var bibleBooks = K.BibleConstants.bibleBooks
    
    
    
    
    func getVerse(_ verse: String) {
        
        let formattedVerse = formatReference(verse)
        var version = String()
        
        
        let urlString = "https://jsonbible.com/search/verses.php?json=\(formattedVerse)"
        
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        
        let url = URL(string: encodedURL!)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url!) { data, response, error in
            let decoder = JSONDecoder()
            
            if data != nil {
                do {
                    let jsonData = try decoder.decode(Bible.self, from: data!)
                    var text = jsonData.text
                    
                    switch versionSelected {
                    case .NASB:
                        version = "NASB"
                    case .NLT:
                        version = "NLT"
                    case .NIV:
                        version = "NIV"
                    }
                    
                    let capFirstLetter = text.first?.uppercased()
                    
                    if let capFirstLetter = capFirstLetter {
                        text.removeFirst()
                        text.insert(Character(capFirstLetter), at: text.startIndex)
                    }
                    
                    self.delegate?.verseReceived(verse: text, copyright: "\(version) ®")
                } catch {
                    self.delegate?.errorReceivingVerse(error: "Error parsing JSON")
                }
            }
        }
        dataTask.resume()
        
    }// End of getVerse
    
    
    func generateDailyVerse() -> String {
        // Array of verses to use as Daily Verse
        let verse = K.BibleConstants.dailyVerses
        
        // Get the current date which is used to determine which verse will be displayed as the verse of the day
        let date = Date()
        // Format the date so that only the day of month is used
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dayOfMonth = dateFormatter.string(from: date)
        if let dayOfMonth = Int(dayOfMonth) {
            //print(verse[dayOfMonth - 1])
            
            // Return the verse reference at the index matching today's day of month
            return verse[dayOfMonth - 1]
        }
        
        // If for some reason getting the day of month fails then generate a random number 0...verse.count and return the verse ref at that index instead
        let randomNumber = Int.random(in: 0...verse.count-1)
        return verse[randomNumber]
    }
    
    func formatReference(_ verse: String) -> String {
        
        // This function essentially breaks down the standard format of writing a verse reference (ie. Romans 12:2 or Romans 12:2-3) and separates it out into different parameters that are put back together in the format required by the API
        
        
        var formattedRef = verse
        var bookID = String()
        var chapter = String()
        var firstVerse = String()
        var lastVerse = String()
        var allVerses = String()
        var version = String()
        
        for (index, book) in bibleBooks.enumerated() {
            if verse.contains(book) {
                bookID = bibleBooks[index]
            }
        }
        
        // Catch if the book is one that starts with a number (ex. 1 Peter, 2 Corinthians).  This has to happen bc the next step is to get chapter which finds the first space and determies position of chapter.  If it's a book with a number then the first space in the string is after the number of book instead of after the book name itself
        if ((formattedRef.first?.isNumber) != nil) {
            formattedRef.removeFirst(2)
        }
        
        // Get the chapter
        guard let spaceIndex = formattedRef.firstIndex(of: " ") else {return ""}
        guard let colonIndex = formattedRef.firstIndex(of: ":") else {return ""}
        chapter = String(formattedRef[spaceIndex...colonIndex])
        chapter.removeFirst() // Removes space
        chapter.removeLast() // Removes colon
        // Get the first verse if second verse is not present
        firstVerse = String(formattedRef[colonIndex...])
        firstVerse.removeFirst()// Removes the colon
        
        // Get the first verse if second verse is present
        if let hyphenIndex = formattedRef.firstIndex(of: "-") {
            firstVerse = String(formattedRef[colonIndex...hyphenIndex])
            firstVerse.removeFirst() // Remove colon
            firstVerse.removeLast() // Remove hyphen
            
            // Get the last verse
            lastVerse = String(formattedRef[hyphenIndex...])
            lastVerse.removeFirst() // Remove hyphen
        }
        
        // Put all the peices back together in the right format depending on whether it is a range of verses or a single verse
        if verse.contains("-") {
            
            guard let first = Int(firstVerse) else {return ""}
            guard let last = Int(lastVerse) else {return ""}
            
            for verse in first...last {
                allVerses.append("\(String(verse)),")
            }
            allVerses = String(allVerses.dropLast())
            
        } else {
            allVerses = firstVerse
            
        }
        
        switch versionSelected {
        case .NASB:
            version = "nasb"
        case .NLT:
            version = "nlt"
        case .NIV:
            version = "niv"
        }
        
            formattedRef =
                """
    { "book": "\(bookID)","chapter": "\(chapter)","verse": "\(allVerses)","version": "\(version)" }
"""
        return (formattedRef)
    } //End formatReference function
}//End of BibleModel
