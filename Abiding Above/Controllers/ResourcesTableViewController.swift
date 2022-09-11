//
//  ResourcesTableViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 8/19/22.
//

import UIKit

class ResourcesTableViewController: UITableViewController {
    
    @IBOutlet weak var discipleshipSchoolImage: UIImageView!
    @IBOutlet weak var discoverGiftImage: UIImageView!
    @IBOutlet weak var readingListImage: UIImageView!
    @IBOutlet weak var recommendedAudioImage: UIImageView!
    @IBOutlet weak var spiritualGrowthImage: UIImageView!
    
    
    @IBOutlet weak var discipleshipSchoolDimmerView: UIView!
    @IBOutlet weak var discoverGiftDimmerView: UIView!
    @IBOutlet weak var readingListDimmerView: UIView!
    @IBOutlet weak var recommendedAudioDimmerView: UIView!
    @IBOutlet weak var spiritualGrowthDimmerView: UIView!
    
    var urlString = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        
        discipleshipSchoolImage.styleView()
        discoverGiftImage.styleView()
        readingListImage.styleView()
        recommendedAudioImage.styleView()
        spiritualGrowthImage.styleView()
        
        discipleshipSchoolDimmerView.styleView()
        discoverGiftDimmerView.styleView()
        readingListDimmerView.styleView()
        recommendedAudioDimmerView.styleView()
        spiritualGrowthDimmerView.styleView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! WebViewController
        destVC.urlString = urlString
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case [0,2]: // Abiding Above Discipleship School selected
            urlString = "https://abidingabove.org/index.php/abiding-above-discipleship-school/"
            performSegue(withIdentifier: "WebViewSegue", sender: self)
        case [0,3]: // Discover your spiritual gift selected
            urlString = "https://abidingabove.org/index.php/discover-your-spiritual-gift/"
            performSegue(withIdentifier: "WebViewSegue", sender: self)
        case [0,4]: // Recommended reading selected
            urlString = "https://abidingabove.org/index.php/recommended-reading-list/"
            performSegue(withIdentifier: "WebViewSegue", sender: self)
        case [0,5]: // Recommended audio selected
            urlString = "https://abidingabove.org/index.php/recommended-audio/"
            performSegue(withIdentifier: "WebViewSegue", sender: self)
        case [0,6]: // Practical helps for spiritual growth
            urlString = "https://abidingabove.org/index.php/practical-helps-for-spiritual-growth/"
            performSegue(withIdentifier: "WebViewSegue", sender: self)
        default:
            break
        }
        
    }
}
