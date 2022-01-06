//
//  DevotionsModel.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/28/21.
//

import Foundation
import Firebase


protocol DevotionDelegate {
    func didRecieveDevotion(devotion: Devotion)
    func didRecieveError(error: String?)
}

struct DevotionsModel {
    
    let db = Firestore.firestore()
    var delegate: DevotionDelegate?
    
    func getAllDevotions() {
        
        db.collection("cities").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let title = data["title"] as? String,
                       let verse = data["verse"] as? String,
                       let body = data["devotion"] as? String
                    /* TODO: Add in the topic field here to allow search by topic*/ {
                        let devotion = Devotion(title: title, verse: verse, body: body)
                        
                    }
                       
                }
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
                       let body = data["devotion"] as? String {
                        
                        let selectedDevotion = Devotion(title: title, verse: verse, body: body)
                        
                        delegate?.didRecieveDevotion(devotion: selectedDevotion)
                    }
                }
            } else {
                print("Document does not exist")
                if error != nil {
                    delegate?.didRecieveError(error: "There was an error retrieving the devotion from the database. \(error!)")
                } else {
                    delegate?.didRecieveError(error: "There was an error retrieving the devotion from the database. Unknown error")
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
    } // End of getCurrentDate
    
}
