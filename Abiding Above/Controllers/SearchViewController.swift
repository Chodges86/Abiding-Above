//
//  SearchTopicViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 11/3/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var topicTableView: UITableView!
    
    var devModel = DevotionsModel()
    let devVC = DevotionViewController()
    
    var allDevotions: [Devotion] = []
    var indexOfSelectedDev:Int = 0
    var topics = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        devModel.allDevDelegate = self
        topicTableView.dataSource = self
        topicTableView.delegate = self
        
        // Get all Devotions from the database for displaying either topics or titles in the tableView
        devModel.getAllDevotions()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Register the TopicCell.xib for use in the tableview
        topicTableView.register(UINib(nibName: "TopicCell", bundle: nil), forCellReuseIdentifier: "topicCell")
        // Style tableview
        topicTableView.backgroundColor = .clear
        topicTableView.separatorStyle = .none
        
        // Hide the tab bar and make back button in nav bar white
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .white
    }
    
   
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Depending on searchMode number of rows changes
        switch searchMode {
        case .title:
            return allDevotions.count
        case .topic:
            return topics.count
        case .today:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = topicTableView.dequeueReusableCell(withIdentifier: "topicCell") as! TopicCell
        
        // Depending on searchMode either display the titles of devotions of topics
        switch searchMode {
        case .title:
            cell.topicLabel.text = allDevotions[indexPath.row].title
        case .topic:
            cell.topicLabel.text = topics[indexPath.row]
        case .today:
            break
        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Depending on searchMode either segue to DevotionViewController with a devotion by title or reload the tableview with titles from the topic selected
        switch searchMode {
        case .title:
            indexOfSelectedDev = Int(indexPath.row)
            performSegue(withIdentifier: "SearchSegue", sender: self)
        case .topic:
            var newDevotions:[Devotion] = []
            for devotion in allDevotions {
                if devotion.topic.contains(topics[Int(indexPath.row)]) {
                    newDevotions.append(devotion)
                }
            }
            allDevotions = newDevotions
            searchMode = .title
            topicTableView.reloadData()
        case .today:
            break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SearchSegue" {
            //Pass in the devotion selected by the user to the DevotionViewController
            let destVC = segue.destination as? DevotionViewController
            destVC?.devotion = allDevotions[indexOfSelectedDev]
            
        }
    }
}

extension SearchViewController: AllDevotionsDelegate {
    func didReceiveAllDevotions(devotions: [Devotion]) {
        allDevotions = devotions
        
        // Reduce topics down so that only one topic of each is shown
        var topicSet:Set<String> = []
        for devotion in devotions {
            for topic in devotion.topic {
                topicSet.insert(topic)
            }
        }
        
        topics.append(contentsOf: topicSet)
        topicTableView.reloadData()
    }
    
    func didRecieveError(error: String?) {
        //TODO: Check to make sure this error message is displayed.  May need to either disconnect internet to computer or empty the database.
        if error != nil {
            let alertService = AlertService()
            let alertVC = alertService.createAlert(error!, "OK")
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    
}
