//
//  HomeTableViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 7/6/22.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    @IBOutlet weak var dailyVerseLabel: UILabel!
    @IBOutlet weak var dailyVerseView: UIView!
    @IBOutlet weak var dailyVerseTitle: UILabel!
    
    @IBOutlet weak var dailyDevotionsView: UIView!
    
    var dailyVerse = String()
    var bibleModel = BibleModel()
    
    override func viewWillAppear(_ animated: Bool) {
        
        bibleModel.delegate = self
        
        styleView(dailyVerseView)
        styleView(dailyDevotionsView)
        
        // Call the getVerse function to kickoff getting the Daily Verse
        bibleModel.getVerse(bibleModel.generateDailyVerse())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func styleView(_ view: UIView) {
        
        view.layer.cornerRadius = 8
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.2
        
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "SettingsSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "VerseSegue" {
            dailyVerse = bibleModel.generateDailyVerse()
            let destVC = segue.destination as! VerseViewController
            destVC.verseRef = dailyVerse
            destVC.verseTitleText = "Daily Verse"
        }
        
    }
    
}

// MARK: - TableView Delegate and Datasource Methods

extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case [0,1]: // Daily Verse selected
            performSegue(withIdentifier: "VerseSegue", sender: self)
        case [0,2]: // Daily Devotions selected
            performSegue(withIdentifier: "DevotionSegue", sender: self)
        default:
            break
        }
        
        
    }
    
}

// MARK: - VerseDelegate Methods

extension HomeTableViewController: VerseDelegate {
    func verseReceived(verse: String, copyright: String) {
        DispatchQueue.main.async {
            
            self.dailyVerseLabel.text = "\(verse)\n\n\(self.bibleModel.generateDailyVerse())"
            self.tableView.reloadData()
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
