//
//  DevotionsModel.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/28/21.
//

import Foundation
import Firebase


protocol DevotionDelegate {
    func didRecieveDevotions(devotion: [Devotion])
    func didRecieveError(error: String?)
}

class DevotionsModel {
    
    let db = Firestore.firestore()
    var delegate: DevotionDelegate?
    
    func getAllDevotions() {
        
        db.collection(K.DevotionConstants.devotionCollection).getDocuments() { (querySnapshot, err) in
            var devotions = [Devotion]()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    if let title = data["title"] as? String,
                       let verse = data["verse"] as? String,
                       let body = data["devotion"] as? String,
                       let topic:Array = data["topic"] as? [String]
                    /* TODO: Add in the topic field here to allow search by topic*/ {
                        let devotion = Devotion(title: title, verse: verse, body: body, topic: topic)
                        devotions.append(devotion)
                    }
                    
                }
                
                //self.delegate?.didRecieveDevotions(devotion: devotions)
            }
        }
        
    }
    
    // Gets the devotion from Firestore based on document name which is the date as a String
    func getDevotion(_ date: String) {
        
        let docRef = db.collection(K.DevotionConstants.devotionCollection).document(date)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(){
                    if let title = data["title"] as? String,
                       let verse = data["verse"] as? String,
                       let body = data["devotion"] as? String,
                       let topic = data["topic"] as? [String] {
                        
                        let selectedDevotion = Devotion(title: title, verse: verse, body: body, topic: topic)
                        let devotion = [selectedDevotion]
                        
                        self.delegate?.didRecieveDevotions(devotion: devotion)
                    }
                }
            } else {
                print("Document does not exist")
                if error != nil {
                    self.delegate?.didRecieveError(error: "There was an error retrieving the devotion from the database. \(error!)")
                } else {
                    self.delegate?.didRecieveError(error: "There was an error retrieving the devotion from the database. Unknown error")
                }
                
            }
        }
    }  // End of getDevotion function
    
    
    func getCurrentDate() -> String {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MM.dd.yyyy"
        let date = dateFormatter.string(from: currentDate)
        return date
    }// End of getCurrentDate
    
    // MARK: - Search database functions
    
    func getAllTopics(_ devotions: [Devotion]) -> [String] {
        
        var set = Set<String>()
        var topics = [String]()
        for devotion in devotions {
            for topic in devotion.topic {
                set.insert(topic)
            }
        }
        for item in set {
            topics.append(item)
        }
        
        return topics
    }
    
    func getDevotionbyTitle(_ title: String) {
        print(title)
        // Create a reference to the collection
        let documents = db.collection("devotions")
        
        // Create a query against the collection.
        let query = documents.whereField("title", isEqualTo: title)
        
        
        query.getDocuments() { snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        if let title = data["title"] as? String,
                           let verse = data["verse"] as? String,
                           let body = data["devotion"] as? String,
                           let topic = data["topic"] as? [String] {
                            
                            let devotion = Devotion(title: title, verse: verse, body: body, topic: topic)
                            let devotions = [devotion]
                            self.delegate?.didRecieveDevotions(devotion: devotions)
                        }
                    }
                }
            }
            
        }
    }
}
