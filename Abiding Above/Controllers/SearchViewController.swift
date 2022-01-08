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
    
    
    var devotions = [Devotion]()
    var topics = [String]()
    var searchMode:SearchMode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topicTableView.dataSource = self
        topicTableView.delegate = self
        topicTableView.register(UINib(nibName: "TopicCell", bundle: nil), forCellReuseIdentifier: "topicCell")
        topicTableView.backgroundColor = .clear
        topicTableView.separatorStyle = .none
        
        devModel.delegate = self
        devModel.getAllDevotions()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .white
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchMode {
        case .title:
            return devotions.count
        case .topic:
            return topics.count
        default:
            return devotions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = topicTableView.dequeueReusableCell(withIdentifier: "topicCell") as! TopicCell
        switch searchMode {
        case .title:
            cell.topicLabel.text = devotions[indexPath.row].title
        case .topic:
            cell.topicLabel.text = topics[indexPath.row]
        default:
            break
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Setup the cell so that clicking on it presents the DevotionViewController with the selected devotion (and setup so that cell is not highlighted)
        let cell = topicTableView.cellForRow(at: indexPath) as? TopicCell
        
        switch searchMode {
        case .title:
            if let title = cell?.topicLabel.text {
                devModel.getDevotionbyTitle(title)
            }
            performSegue(withIdentifier: "SearchDevSegue", sender: self)
        case .topic:
            // Setup getting a list of devotions from the selected topic
            break
        default:
            break
        }
    }
}

extension SearchViewController: DevotionDelegate {
    func didRecieveDevotions(devotion: [Devotion]) {
        switch searchMode {
        case .title:
            devotions = devotion
            topicTableView.reloadData()
        case .topic:
            topics = devModel.getAllTopics(devotion)
            topicTableView.reloadData()
        default:
            break
        }
    }

    func didRecieveError(error: String?) {
        // Handle error
    }
    
    
    
}
