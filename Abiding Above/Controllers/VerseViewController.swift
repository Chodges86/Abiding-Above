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
    
    var verseRef = String()
    var bibleModel = BibleModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bibleModel.delegate = self
        // Kickoff the getVerse function to display
        bibleModel.getVerse(verseRef)
        
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
        verseLabel.text = verse + " -" + verseRef
    }
}
