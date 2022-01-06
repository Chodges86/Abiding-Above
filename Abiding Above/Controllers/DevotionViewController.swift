//
//  DevotionViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/25/21.
//

import UIKit

class DevotionViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var verseButton: UIButton!
    @IBOutlet weak var devLabel: UILabel!
    
    var devModel = DevotionsModel()
    var bibleModel = BibleModel()
    var date: String? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        devModel.delegate = self
        if let date = date {
            // Kickoff the getDevotion function to get a Devotion from Firestore database
            devModel.getDevotion(date)
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    @IBAction func verseTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "verseSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass verse reference from the title of button to the VerseVC so that it can be displayed when user presses the button
        let destVC = segue.destination as! VerseViewController
        guard let verse = verseButton.titleLabel?.text else {return}
        destVC.verseRef = verse
    }
    
}

// MARK: - Devotion Delegate Protocols
extension DevotionViewController: DevotionDelegate {
    func didRecieveError(error: String?) {
        if error != nil {
            let alertService = AlertService()
            let alertVC = alertService.createAlert(error!, "OK")
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func didRecieveDevotion(devotion: Devotion) {
        DispatchQueue.main.async {
            // Devotion received and placed into view 
            self.titleLabel.text = devotion.title
            self.verseButton.setTitle(devotion.verse, for: .normal)
            self.devLabel.text = devotion.body
        }
    }
}
