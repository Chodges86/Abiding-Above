//
//  SelectDevTableViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 7/11/22.
//

import UIKit

class SelectDevTableViewController: UITableViewController {

    @IBOutlet weak var todaysDevImage: UIImageView!
    @IBOutlet weak var searchTitleImage: UIImageView!
    @IBOutlet weak var searchTopicImage: UIImageView!
    @IBOutlet weak var bookmarkImage: UIImageView!
    
    @IBOutlet weak var todaysDevDimmerView: UIView!
    @IBOutlet weak var searchTitleDimmerView: UIView!
    @IBOutlet weak var searchTopicDimmerView: UIView!
    @IBOutlet weak var bookmarkDimmerView: UIView!
    
    var devModel = DevotionsModel()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        todaysDevImage.styleView()
        searchTitleImage.styleView()
        searchTopicImage.styleView()
        bookmarkImage.styleView()
        
        todaysDevDimmerView.styleView()
        searchTitleDimmerView.styleView()
        searchTopicDimmerView.styleView()
        bookmarkDimmerView.styleView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case [0,0]:
            navigationController?.popToRootViewController(animated: true)
        case [0,2]:
            searchMode = .today
            performSegue(withIdentifier: "DevSegue", sender: self)
        case [0,3]:
            searchMode = .title
            performSegue(withIdentifier: "TableViewSegue", sender: self)
        case [0,4]:
            searchMode = .topic
            performSegue(withIdentifier: "TableViewSegue", sender: self)
        case [0,5]:
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
            let currentdate = devModel.getCurrentDate()
            destVC.date = currentdate
        }
    }
    
}
