//
//  GiveViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/20/21.
//

import UIKit
import WebKit

class GiveViewController: UIViewController {
    
    @IBOutlet weak var donationStatement: UILabel!
    @IBOutlet weak var donateHereTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donateHereTextView.automaticallyAdjustsScrollIndicatorInsets = false
        
        updateTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        donationStatement.layer.shadowOpacity = 0.3
        donationStatement.layer.shadowOffset = CGSize(width: 10, height: 10)
        donationStatement.layer.shadowRadius = 5
        
        donateHereTextView.layer.shadowOpacity = 0.3
        donateHereTextView.layer.shadowOffset = CGSize(width: 10, height: 10)
        donateHereTextView.layer.shadowRadius = 5
        
        // Set tabBar back to default so that it will be more visible with website content
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.backgroundImage = nil
        tabBarController?.tabBar.shadowImage = nil
        tabBarController?.tabBar.clipsToBounds = false
        
    }
    func updateTextView() {
        
        let path = "https://abidingabove.org/index.php/donations/give/"
        let text = donateHereTextView.text ?? ""
        let attributedString = NSAttributedString.makeHyperLink(for: path, in: text, as: "here")
        let font = donateHereTextView.font
        let color = donateHereTextView.textColor
        
        donateHereTextView.attributedText = attributedString
        donateHereTextView.linkTextAttributes = [.underlineStyle: 1]
        donateHereTextView.font = font
        donateHereTextView.textColor = color
        
    }
}

extension NSAttributedString {
 
    static func makeHyperLink(for path: String, in string: String, as substring: String) -> NSAttributedString {
        
        let nsString = NSString(string: string)
        let subStringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: subStringRange)
        return attributedString
    }
}
