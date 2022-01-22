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
        
        devModel.singleDevDelegate = self
        
        verseButton.isHidden = true
        
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        
        if let devotion = devotion {
            displayDevotion(devotion)
        }
        if searchMode == .today {
            if let date = date {
                devModel.getDevotion(date)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .white
        titleLabel.layer.shadowRadius = 5
        titleLabel.layer.shadowOffset = CGSize(width: 10, height: 10)
        titleLabel.layer.shadowOpacity = 0.3
        verseButton.layer.shadowRadius = 5
        verseButton.layer.shadowOffset = CGSize(width: 10, height: 10)
        verseButton.layer.shadowOpacity = 0.3
        verseButton.layer.cornerRadius = 10
        
    }
    
    func displayDevotion(_ devotion: Devotion) {
        
        self.verseButton.isHidden = false
        self.titleLabel.text = devotion.title
        self.verseButton.setTitle("  \(devotion.verse)  ", for: .normal)
        self.devLabel.text = devotion.body
        
    }
    
    @IBAction func verseTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "VerseSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass verse reference from the title of button to the VerseVC so that it can be displayed when user presses the button
        let destVC = segue.destination as! VerseViewController
        guard let verse = devotion?.verse else {return}
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
