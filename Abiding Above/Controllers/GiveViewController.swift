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
    @IBOutlet weak var donationStatementView: UIView!
    @IBOutlet weak var backgroundImageDimmerView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        donationStatementView.styleView()
        backgroundImage.styleView()
        backgroundImageDimmerView.styleView()
        
        donateHereTextView.automaticallyAdjustsScrollIndicatorInsets = false
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(homeTapped(_:)))
        logo.isUserInteractionEnabled = true
        logo.addGestureRecognizer(recognizer)
        
        updateTextView()
    }
    
    @objc func homeTapped(_ recognizer: UITapGestureRecognizer) {
        navigationController?.popToRootViewController(animated: true)
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


