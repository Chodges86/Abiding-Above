//
//  DevotionsModel.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/28/21.
//

import Foundation
import Firebase



// Protocol used by SearchViewController. func getAllDevotions returns to delegate an array of all devotions in the database
protocol AllDevotionsDelegate {
    func didReceiveAllDevotions(devotions: [Devotion])
    func didRecieveError(error: String?)
}
// Protocol used by DevotionViewController. func getDevotion returns to delegate a single devotion in the database
protocol SingleDevotionDelegate {
    func didRecieveDevotion(devotion: Devotion)
    func didRecieveError(error: String?)
}

struct DevotionsModel {
    
    let db = Firestore.firestore()
    var singleDevDelegate: SingleDevotionDelegate?
    var allDevDelegate: AllDevotionsDelegate?

// MARK: - Methods for getting devotions from FireStore
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
                if !allDevotions.isEmpty {
                    allDevDelegate?.didReceiveAllDevotions(devotions: allDevotions)
                } else {
                    allDevDelegate?.didRecieveError(error: "Could not connect to the database.  Please check internet connection and try again")
                }
                
            }
        }
    }// End getAllDevotions
    
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
