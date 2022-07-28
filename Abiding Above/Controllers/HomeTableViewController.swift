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
    @IBOutlet weak var newsletterView: UIView!
    @IBOutlet weak var avView: UIView!
    @IBOutlet weak var giveView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var dailyVerse = String()
    var bibleModel = BibleModel()
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        
        
        bibleModel.delegate = self
        
        dailyVerseView.styleView()
        dailyDevotionsView.styleView()
        newsletterView.styleView()
        avView.styleView()
        giveView.styleView()
        
        
        // Call the getVerse function to kickoff getting the Daily Verse
        bibleModel.getVerse(bibleModel.generateDailyVerse())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        spinner.alpha = 1
        spinner.startAnimating()
        
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
        case [0,3]: // Newsletter selected
            urlNavMode = .newsletter
            performSegue(withIdentifier: "WebViewSegue", sender: self)
        case [0,4]: // AV selected
            urlNavMode = .av
            performSegue(withIdentifier: "WebViewSegue", sender: self)
        case [0,5]: // Give selected
            performSegue(withIdentifier: "GiveSegue", sender: self)
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
            self.spinner.alpha = 0
            self.spinner.startAnimating()
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

extension UIView {
    
    func styleView() {
        
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        
    }
    
}
