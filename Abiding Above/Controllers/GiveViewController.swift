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


