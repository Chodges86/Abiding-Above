//
//  DailyDevViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/20/21.
//

import UIKit


class DailyDevViewController: UIViewController {
    
    var devModel = DevotionsModel()
    var searchVC = SearchViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set nav bar to be clear
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Make the tabBar transparent
        tabBarController?.tabBar.backgroundColor = .none
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.clipsToBounds = true
    }
    
    @IBAction func todayDevPressed(_ sender: UIButton) {
        searchMode = .today
        performSegue(withIdentifier: "DevSegue", sender: self)
    }
    
    @IBAction func searchTopicPressed(_ sender: UIButton) {
        searchMode = .topic
        performSegue(withIdentifier: "TableView Segue", sender: self)
    }
    
    @IBAction func searchTitlePressed(_ sender: UIButton) {
        searchMode = .title
        performSegue(withIdentifier: "TableView Segue", sender: self)
    }
    @IBAction func bookmarksPressed(_ sender: UIButton) {
        searchMode = .bookmarked
        performSegue(withIdentifier: "TableView Segue", sender: self)
    }
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "DevToSettings", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass in the current date for the DevotionVC to use when getting the correct devotion from the Firestore database
        if segue.identifier == "DevSegue" {
            let destVC = segue.destination as! DevotionViewController
            // Call a func from the DevotionsModel that gets today's date
            let currentdate = devModel.getCurrentDate()
            // Pass that date back into the date property of the destVC
            destVC.date = currentdate
        } 
    }
}
