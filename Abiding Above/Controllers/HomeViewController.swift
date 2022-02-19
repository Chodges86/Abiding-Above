//
//  ViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/11/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var verseView: UIView!
    @IBOutlet weak var verseLabel: UILabel!
    @IBOutlet weak var refLabel: UILabel!
    @IBOutlet weak var dailyVerseLabel: UILabel!
    @IBOutlet weak var copyright: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var bibleModel = BibleModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bibleModel.delegate = self
        // Call the getVerse function to kickoff getting the Daily Verse
        bibleModel.getVerse(bibleModel.generateDailyVerse())
        
        spinner.alpha = 1
        spinner.startAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Hide the Navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Make the tabBar transparent
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.clipsToBounds = true
        
        // Setup the daily verse layout
        //        verseView.layer.cornerRadius = 25
        verseView.layer.shadowOffset = CGSize(width: 10, height: 10)
        verseView.layer.shadowRadius = 5
        verseView.layer.shadowOpacity = 0.3
        dailyVerseLabel.layer.shadowOffset = CGSize(width: 10, height: 10)
        dailyVerseLabel.layer.shadowRadius = 5
        refLabel.layer.shadowOpacity = 0.3
        refLabel.layer.shadowOffset = CGSize(width: 10, height: 10)
        refLabel.layer.shadowRadius = 5
        dailyVerseLabel.layer.shadowOpacity = 0.3
        
    }
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "HomeToSettings", sender: self)
        
    }
    
    @IBAction func copyrightTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToCopyrightSegue", sender: self)
    }
    
}
// MARK: - VerseDelegate Methods

extension HomeViewController: VerseDelegate {
    func verseReceived(verse: String, copyright: String) {
        DispatchQueue.main.async {
            self.spinner.alpha = 0
            self.spinner.stopAnimating()
            // Verse received and placed into labels
            self.verseLabel.text = verse
            self.refLabel.text = self.bibleModel.generateDailyVerse()
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
