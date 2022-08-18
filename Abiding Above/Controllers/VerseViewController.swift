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
    @IBOutlet weak var copyright: UIButton!
    @IBOutlet weak var verseTitle: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var verseRef = String()
    var bibleModel = BibleModel()
    var verseTitleText = String()
    
    override func viewWillAppear(_ animated: Bool) {
        
        verseView.styleView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.alpha = 1
        spinner.startAnimating()
        
        bibleModel.delegate = self
        
        // Kickoff the getVerse function to display
        bibleModel.getVerse(verseRef)
        
        verseTitle.text = verseTitleText
        
        
        
    }
    
    @IBAction func copyrightPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "VerseToCopyrightSegue", sender: self)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss VC when user taps screen
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension VerseViewController: VerseDelegate {
    func verseReceived(verse: String, copyright: String) {
        DispatchQueue.main.async {
            self.spinner.alpha = 0
            self.spinner.stopAnimating()
            // Verse received and placed into label with the reference added to the end
            self.verseLabel.text = verse
            self.refLabel.text = self.verseRef
            self.copyright.setTitle(copyright, for: .normal)
            
        }
    }
    func errorReceivingVerse(error: String?) {
        
        DispatchQueue.main.async {
            if error != nil {
                let alertService = AlertService()
                let alertVC = alertService.createAlert(error!, "OK")
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
}
