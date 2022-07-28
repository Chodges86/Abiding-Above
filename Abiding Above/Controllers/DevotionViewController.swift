//
//  DevotionViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/25/21.
//

import UIKit



class DevotionViewController: UIViewController {
    
    var devModel = DevotionsModel()
    var bibleModel = BibleModel()
    var date: String?
    var devotion: Devotion?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var verseLabel: UILabel!
    @IBOutlet weak var devLabel: UILabel!
    @IBOutlet weak var devotionView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var grayLineView: UIView!
    @IBOutlet weak var bookmark: UIBarButtonItem!
    
    var isBookmarked: Bool = false
    
    let defaults = UserDefaults.standard // Bookmark data persistance
    
    let symbolConfig = UIImage.SymbolConfiguration(scale: .large) // Config for bookmark button

    
    override func viewWillAppear(_ animated: Bool) {
        
        // Diplay logo in the navigation bar which at this point is set to clear background
        let logo = UIImage(named: "logoNavBar")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        navigationItem.titleView = imageView
                
        
        // Hide tab bar
        tabBarController?.tabBar.isHidden = true
        
        devModel.loadBookmarkedDevotions()
        
        if !bookmarkedDevotions.isEmpty {
            for id in bookmarkedDevotions {
                guard devotion?.id != nil else {return}
                if id == devotion?.id {
                    bookmark.image = UIImage(systemName: "bookmark.fill", withConfiguration: symbolConfig)
                    isBookmarked = true
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.alpha = 1
        spinner.startAnimating()
        
        grayLineView.isHidden = true
        
        devModel.singleDevDelegate = self
        bibleModel.delegate = self
        // Hide the verse button at first until the BibleModel returns a verse.  Without this a blank button will be displayed in the event no verse comes back from the API
        verseLabel.isHidden = true
        
        
        
        // Display the devotion passed from SearchViewController when view loads
        if let devotion = devotion {
            bibleModel.getVerse(devotion.verse)
        }
        // call getDevotion from DevotionModel with today's date if arrived to this view from the Today's Devotion button
        if searchMode == .today {
            if let date = date {
                devModel.getDevotion(date)
            }
        }
    }
    
    func displayDevotion(_ devotion: Devotion, _ verse: String) {
        
        verseLabel.isHidden = false
        titleLabel.text = devotion.title
        verseLabel.text = "\(devotion.verse) \n\n \(verse)"
        devLabel.text = devotion.body
        spinner.alpha = 0
        spinner.stopAnimating()
        grayLineView.isHidden = false
    }
    
    @IBAction func bookmarkTapped(_ sender: UIBarButtonItem) {
        
        guard devotion?.id != nil else {return}
        
        
        isBookmarked = !isBookmarked
        if isBookmarked {
            bookmark.image = UIImage(systemName: "bookmark.fill", withConfiguration: symbolConfig)
            if !bookmarkedDevotions.contains(devotion!.id) {
                bookmarkedDevotions.append(devotion!.id)
            }
            defaults.set(bookmarkedDevotions, forKey: "bookmarks")
            
        } else {
            bookmark.image = UIImage(systemName: "bookmark", withConfiguration: symbolConfig)
            for (index, id) in bookmarkedDevotions.enumerated() {
                if devotion!.id == id {
                    bookmarkedDevotions.remove(at: index)
                    defaults.set(bookmarkedDevotions, forKey: "bookmarks")
                }
            }
        }
        
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
            self.bibleModel.getVerse(devotion.verse)
        }
    }
}

// MARK: - Verse Delegate Methods
extension DevotionViewController: VerseDelegate {
    
    func verseReceived(verse: String, copyright: String) {
        
        if let devotion = devotion {
            DispatchQueue.main.async {
                self.displayDevotion(devotion, verse)
            }
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

