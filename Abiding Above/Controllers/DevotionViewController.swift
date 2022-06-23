//
//  DevotionViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/25/21.
//

import UIKit

var bookmarkedDevotions = [String]()

class DevotionViewController: UIViewController {
    
    var devModel = DevotionsModel()
    var bibleModel = BibleModel()
    var date: String?
    var devotion: Devotion?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var verseButton: UIButton!
    @IBOutlet weak var devLabel: UILabel!
    @IBOutlet weak var bookmark: UIButton!
    
    var isBookmarked: Bool = false
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        devModel.singleDevDelegate = self
        
        // Hide the verse button at first until the BibleModel returns a verse.  Without this a blank button will be displayed in the event no verse comes back from the API
        verseButton.isHidden = true
        
        // Diplay logo in the navigation bar which at this point is set to clear background
        let logo = UIImage(named: "logoNavBar")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        
        // Display the devotion passed from SearchViewController when view loads
        if let devotion = devotion {
            displayDevotion(devotion)
        }
        // call getDevotion from DevotionModel with today's date if arrived to this view from the Today's Devotion button
        if searchMode == .today {
            if let date = date {
                devModel.getDevotion(date)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Hide tab bar
        tabBarController?.tabBar.isHidden = true
        // Make back button white
        navigationController?.navigationBar.tintColor = .white
        // Shadow effects for title and verse reference button
        titleLabel.layer.shadowRadius = 5
        titleLabel.layer.shadowOffset = CGSize(width: 10, height: 10)
        titleLabel.layer.shadowOpacity = 0.3
        verseButton.layer.shadowRadius = 5
        verseButton.layer.shadowOffset = CGSize(width: 10, height: 10)
        verseButton.layer.shadowOpacity = 0.3
        verseButton.layer.cornerRadius = 10
        
        bookmarkedDevotions = defaults.array(forKey: "bookmarks") as? [String] ?? []
        
        if !bookmarkedDevotions.isEmpty {
            for id in bookmarkedDevotions {
                guard devotion?.id != nil else {return}
                if id == devotion?.id {
                    bookmark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                    isBookmarked = true
                }
            }
        }
        
    }
    
    func displayDevotion(_ devotion: Devotion) {
        
        self.verseButton.isHidden = false
        self.titleLabel.text = devotion.title
        self.verseButton.setTitle("  \(devotion.verse)  ", for: .normal)
        self.devLabel.text = devotion.body
        
    }
    
    @IBAction func bookmarkTapped(_ sender: UIButton) {
        
        guard devotion?.id != nil else {return}
        
        isBookmarked = !isBookmarked
        if isBookmarked {
            bookmark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            if !bookmarkedDevotions.contains(devotion!.id) {
                bookmarkedDevotions.append(devotion!.id)
            }
            defaults.set(bookmarkedDevotions, forKey: "bookmarks")
            
        } else {
            bookmark.setImage(UIImage(systemName: "bookmark"), for: .normal)
            for (index, id) in bookmarkedDevotions.enumerated() {
                if devotion!.id == id {
                    bookmarkedDevotions.remove(at: index)
                    defaults.set(bookmarkedDevotions, forKey: "bookmarks")
                }
            }
        }
        
    }
    
    
    @IBAction func verseTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "VerseSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the verse reference to the VerseViewController when the verse button is pressed
        let destVC = segue.destination as! VerseViewController
        guard let verse = devotion?.verse else {return}
        destVC.verseRef = verse
    }
}

// MARK: - Devotion Delegate Protocols
extension DevotionViewController: SingleDevotionDelegate {
    func didRecieveError(error: String?) {
        if error != nil {
            let alertService = AlertService()
            let alertVC = alertService.createAlert(error!, "OK")
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func didRecieveDevotion(devotion: Devotion) {
        DispatchQueue.main.async {
            // Devotion received and placed into view
            self.devotion = devotion
            self.displayDevotion(devotion)
        }
    }
}
