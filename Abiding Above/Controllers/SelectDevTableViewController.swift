//
//  SelectDevTableViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 7/11/22.
//

import UIKit

class SelectDevTableViewController: UITableViewController {

    @IBOutlet weak var todaysDevView: UIView!
    @IBOutlet weak var searchTitleView: UIView!
    @IBOutlet weak var searchTopicView: UIView!
    @IBOutlet weak var bookmarkView: UIView!
    
    var devModel = DevotionsModel()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        
        todaysDevView.styleView()
        searchTitleView.styleView()
        searchTopicView.styleView()
        bookmarkView.styleView()
        

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case [0,0]:
            navigationController?.popToRootViewController(animated: true)
        case [0,1]:
            searchMode = .today
            performSegue(withIdentifier: "DevSegue", sender: self)
        case [0,2]:
            searchMode = .title
            performSegue(withIdentifier: "TableViewSegue", sender: self)
        case [0,3]:
            searchMode = .topic
            performSegue(withIdentifier: "TableViewSegue", sender: self)
        case [0,4]:
            searchMode = .bookmarked
            performSegue(withIdentifier: "TableViewSegue", sender: self)
        default:
            break
        }
        
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
