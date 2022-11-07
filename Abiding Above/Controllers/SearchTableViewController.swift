//
//  SearchTableViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 7/11/22.
//

import UIKit

// Case selected depending on which way the user decides to access a devotion from the database
enum SearchMode {
    case title
    case topic
    case today
    case bookmarked
}
var searchMode:SearchMode = .title


class SearchTableViewController: UITableViewController {
    
    var devModel = DevotionsModel()
    
    var allDevotions: [Devotion] = []
    var indexOfSelectedDev:Int = 0
    var topics = [String]()
    var bookmarked : [Devotion] = []
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        for (index, devotion) in bookmarked.enumerated() {
            if !bookmarkedDevotions.contains(devotion.id) {
                bookmarked.remove(at: index)
            }
        }
        
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        devModel.allDevDelegate = self
        
        // Get all Devotions from the database for displaying either topics or titles in the tableView
        devModel.getAllDevotions()
        
        // Load the bookmarked devotions for display in the event user taps Bookmarked
        devModel.loadBookmarkedDevotions()
        
        // Put the logo in the navigation bar
        let logo = UIImage(named: "logoNavBar")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
       
       
        
        setLoadingScreen()
        
    }
   
    
    func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 30
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x-(width/2), y: y-(height/2), width: width, height: height)
        
        
        // Sets spinner
        spinner.frame = CGRect(x: loadingView.frame.width/2, y: 0, width: 30, height: 30)
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        
        tableView.addSubview(loadingView)
        
    }
    
    func removeLoadingScreen() {
        
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
        
    }
    
    var imageNumber = 1
    
    func setImageToUse() -> UIImage {
        
        let image = UIImage(named: "landscape\(imageNumber)")
        
        if imageNumber < 10 {
            imageNumber += 1
        } else {
            imageNumber = 1
        }
        if let image = image {
            return image
        } else {
            return UIImage()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch searchMode {
        case .title:
            return allDevotions.count
        case .topic:
            return topics.count
        case .today:
            return 0
        case .bookmarked:
            return bookmarked.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchField") as! SearchTableViewCell
        
        // Depending on searchMode either display the titles of devotions of topics
        switch searchMode {
            
        case .title:
            cell.searchTitle.text = allDevotions[indexPath.row].title
            cell.searchMetaData.text = allDevotions[indexPath.row].verse
            cell.backgroundImage.image = setImageToUse()
            
        case .topic:
            cell.searchTitle.text = topics[indexPath.row]
            
            var titlesOfTopic = String()
            for devotion in allDevotions {
                if devotion.topic.contains(topics[indexPath.row]) {
                    titlesOfTopic.append("\(devotion.title), ")
                }
            }
            titlesOfTopic.removeLast(2)
            cell.searchMetaData.text = titlesOfTopic
            cell.backgroundImage.image = setImageToUse()
            
        case .today:
            break
            
        case .bookmarked:
            cell.searchTitle.text = bookmarked[indexPath.row].title
            cell.backgroundImage.image = setImageToUse()
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            self.tableView.reloadData()
        case .today:
            break
        case .bookmarked:
            allDevotions = bookmarked
            indexOfSelectedDev = Int(indexPath.row)
            performSegue(withIdentifier: "SearchSegue", sender: self)
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

// MARK: - Devotion Delegate Meth

extension SearchTableViewController: AllDevotionsDelegate {
    func didReceiveAllDevotions(devotions: [Devotion]) {
        
        allDevotions = devotions.sorted {$0.title < $1.title}
        
        // Reduce topics down so that only one topic of each is shown
        var topicSet:Set<String> = []
        for devotion in devotions {
            for topic in devotion.topic {
                topicSet.insert(topic)
            }
        }
        
        topics.append(contentsOf: topicSet.sorted {$0 < $1})
        
        for devotion in allDevotions {
            if bookmarkedDevotions.contains(devotion.id) {
                bookmarked.append(devotion)
            }
        }
        tableView.reloadData()
        removeLoadingScreen()
    }
    
    func didRecieveError(error: String?) {
        
        if error != nil {
            let alertService = AlertService()
            let alertVC = alertService.createAlert(error!, "OK")
            present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    
}
