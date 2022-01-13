//
//  DevotionViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/25/21.
//

import UIKit

class DevotionViewController: UIViewController {
    
    var devModel = DevotionsModel()
    var bibleModel = BibleModel()
    var date: String?
    var devotion: Devotion?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var verseButton: UIButton!
    @IBOutlet weak var devLabel: UILabel!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let devotion = devotion {
            displayDevotion(devotion)
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    func displayDevotion(_ devotion: Devotion) {
        
            self.titleLabel.text = devotion.title
            self.verseButton.setTitle(devotion.verse, for: .normal)
            self.devLabel.text = devotion.body

    }
    
    @IBAction func verseTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "VerseSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass verse reference from the title of button to the VerseVC so that it can be displayed when user presses the button
        let destVC = segue.destination as! VerseViewController
        guard let verse = verseButton.titleLabel?.text else {return}
        destVC.verseRef = verse
    }
    
}

// MARK: - Devotion Delegate Protocols
extension DevotionViewController: SingleDevotionDelegate {
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
            self.displayDevotion(devotion)
        }
    }
}
