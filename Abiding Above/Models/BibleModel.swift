//
//  BibleModel.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 11/4/21.
//

import Foundation

protocol VerseDelegate {
    func verseReceived(verse: String)
}

struct BibleModel {
    
    var delegate: VerseDelegate?
    
    let apiKey = K.BibleConstants.apiKey
    
    // Dictionary of all the books of the Bible and their book ID associated with them within the API (Needed for getting a verse from the API)
    var bookDictionary = K.BibleConstants.bookDictionary
    
    
    func getVerse(_ verse: String) {
        
        // Get a verse reference in the correct format for the API call
        let selectedVerse = self.formatReference(verse)
        
        // Creat URL object
        let urlString = "https://api.scripture.api.bible/v1/bibles/bba9f40183526463-01/verses/\(selectedVerse)"
        let url = URL(string: urlString)
        guard url != nil else {
            print("url was nil")
            return
        }
        
        // Create a request with the headers required for API call
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(apiKey, forHTTPHeaderField: "api-key")
        
        // Create a session
        let session = URLSession.shared
        
        // Decode the JSON
        let decoder = JSONDecoder()
        let dataTask = session.dataTask(with: request) { data, response, error in
            do {
                if error == nil && data != nil {
                    let apiData = try decoder.decode(Bible.PassageData.self, from: data!)
                    let data = apiData.data
                    let htmlString = data.content
                    
                    // JSON result for content value comes back with HTML tags.  Next line removes tags
                    var verse = htmlString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    // Next line takes the verse ref number out of the content value as well as | that shows up in some verses
                    let numbers:Set<Character> = ["1","2","3","4","5","6","7","8","9","0","|",":","-","(",")"]
                    verse.removeAll(where: { numbers.contains($0) })
                    // Capitalize the first letter
                    if let firstLetter = verse.first?.uppercased() {
                        let finalVerse = verse.replacingCharacters(in: ...verse.startIndex, with: firstLetter)
                        
                        // Tell the delegate that a verse is ready for use
                        DispatchQueue.main.async {
                            delegate?.verseReceived(verse: finalVerse)
                        }
                    }
                }
                
            } catch {
                // TODO: Handle error
                print("Could not parse JSON into a verse, \(error)")
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
        // This function essentially breaks down the standard format of writing a verse reference (ie. Romans 12:2 or Romans 12:2-3) and separates it out into different parameters that are put back together in the format required by the API (ie. ROM.12.2 or ROM.12.2-ROM.12.3)
        
        
        var formattedRef = verse
        var bookID = String()
        var chapter = String()
        var firstVerse = String()
        var lastVerse = String()
        
        // Get the bookID required by the API
        for key in bookDictionary.keys {
            if verse.contains(String(key)) {
                bookID = bookDictionary[key]!
                
            }
        }
        // Catch if the book is one that starts with a number (ex. 1 Peter, 2 Corinthians).  This has to happen bc the next step is to get chapter which finds the first space and determies position of chapter.  If it's a book with a number then the first space in the string is after the number of book instead of after the book name itself
        if (formattedRef.first?.isNumber) != nil {
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
            formattedRef = "\(bookID).\(chapter).\(firstVerse)-\(bookID).\(chapter).\(lastVerse)"
        } else {
            formattedRef = "\(bookID).\(chapter).\(firstVerse)"
        }
        return formattedRef
    } //End formatReference function
}//End of BibleModel
