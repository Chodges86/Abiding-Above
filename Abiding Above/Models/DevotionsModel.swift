//
//  DevotionsModel.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/28/21.
//

import Foundation
import Firebase

enum SearchMode {
    case title
    case topic
    case today
}
var searchMode:SearchMode = .title

protocol AllDevotionsDelegate {
    func didReceiveAllDevotions(devotions: [Devotion])
    func didRecieveError(error: String?)
}

protocol SingleDevotionDelegate {
    func didRecieveDevotion(devotion: Devotion)
    func didRecieveError(error: String?)
}

struct DevotionsModel {
    
    let db = Firestore.firestore()
    var singleDevDelegate: SingleDevotionDelegate?
    var allDevDelegate: AllDevotionsDelegate?
    
    
    func getAllDevotions() {
        
        db.collection("devotions").getDocuments { (querySnapshot, err) in
            var allDevotions = [Devotion]()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let date = data["date"] as? String,
                       let title = data["title"] as? String,
                       let verse = data["verse"] as? String,
                       let body = data["devotion"] as? String,
                       let topic = data["topic"] as? [String] {
                        let devotion = Devotion(date: date, title: title, verse: verse, body: body, topic: topic)
                        allDevotions.append(devotion)
                        
                    }
                }
                allDevDelegate?.didReceiveAllDevotions(devotions: allDevotions)
                
            }
        }
    }
    
    // Gets the devotion from Firestore based on document name which is the date as a String
    func getDevotion(_ date: String) {
        
        var devotions:[Devotion] = []
        
        db.collection("devotions").whereField("date", isEqualTo: date)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let date = data["date"] as? String,
                           let title = data["title"] as? String,
                           let verse = data["verse"] as? String,
                           let body = data["devotion"] as? String,
                           let topic = data["topic"] as? [String] {
                            
                            let devotion = Devotion(date: date, title: title, verse: verse, body: body, topic: topic)
                            devotions.append(devotion)
                        }
                    }
                    //TODO: Error Index out of range here when no devotion for todays date is in database
                    if !devotions.isEmpty {
                        singleDevDelegate?.didRecieveDevotion(devotion: devotions[0])
                    } else {
                        singleDevDelegate?.didRecieveError(error: "Devotion not available. Please check internet connection and try again.")
                    }
                }
            }
    }  // End of getDevotion function
    
    
    func getCurrentDate() -> String {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.string(from: currentDate)
        return date
    } // End of getCurrentDate
    
}
