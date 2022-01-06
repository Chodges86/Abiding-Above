//
//  SearchTopicViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 11/3/21.
//

import UIKit

class SearchTopicViewController: UIViewController {
    
    @IBOutlet weak var topicTableView: UITableView!
    
    
    let exampleArray = ["Marriage", "Leadership", "Love", "Forgiveness", "Apologetics", "Pride"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topicTableView.dataSource = self
        topicTableView.delegate = self
        topicTableView.register(UINib(nibName: "TopicCell", bundle: nil), forCellReuseIdentifier: "topicCell")
        topicTableView.backgroundColor = .clear
        topicTableView.separatorStyle = .none
        

        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .white
        
    }
    
}

extension SearchTopicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = topicTableView.dequeueReusableCell(withIdentifier: "topicCell") as! TopicCell
        cell.topicLabel.text = exampleArray[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
}
