//
//  VerseViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 12/5/21.
//

import UIKit

class VerseViewController: UIViewController {

    @IBOutlet weak var verseLabel: UILabel!
    @IBOutlet weak var verseView: UIView!
    @IBOutlet weak var refLabel: UILabel!
    
    var verseRef = String()
    var bibleModel = BibleModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bibleModel.delegate = self
        // Kickoff the getVerse function to display
        bibleModel.getVerse(verseRef)
        
        refLabel.layer.shadowOffset = CGSize(width: 10, height: 10)
        refLabel.layer.shadowRadius = 5
        refLabel.layer.shadowOpacity = 0.3
        
        verseLabel.layer.shadowOffset = CGSize(width: 10, height: 10)
        verseLabel.layer.shadowRadius = 5
        verseLabel.layer.shadowOpacity = 0.3
        
        verseView.layer.cornerRadius = 20

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // Dismiss VC when user taps screen
            self.dismiss(animated: true, completion: nil)
        
    }
}

extension VerseViewController: VerseDelegate {
    func verseReceived(verse: String) {
        // Verse received and placed into label with the reference added to the end
        // TODO: Add the bible version 
        verseLabel.text = verse
        refLabel.text = verseRef
    }
}
