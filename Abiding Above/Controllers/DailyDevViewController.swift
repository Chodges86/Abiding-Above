//
//  DailyDevViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/20/21.
//

import UIKit

enum SearchMode {
    case title
    case topic
}

class DailyDevViewController: UIViewController {
    
    var model = DevotionsModel()
    var searchMode:SearchMode?
    
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
    }
    
    @IBAction func todayDevPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "DevSegue", sender: self)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            searchMode = .title
        } else if sender.tag == 2 {
            searchMode = .topic
        }
        performSegue(withIdentifier: "TableView Segue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass in the current date for the DevotionVC to use when getting the correct devotion from the Firestore database
        if segue.identifier == "DevSegue" {
            let destVC = segue.destination as! DevotionViewController
            // Call a func from the DevotionsModel that gets today's date
            let currentdate = model.getCurrentDate()
            // Pass that date back into the date property of the destVC
            destVC.date = currentdate
        } else if segue.identifier == "TableView Segue" {
            let destVC = segue.destination as! SearchViewController
            destVC.searchMode = searchMode
        }
    }
}
