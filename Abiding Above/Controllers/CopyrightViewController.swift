//
//  CopyrightViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 6/23/22.
//

import UIKit

class CopyrightViewController: UIViewController {

    @IBOutlet weak var lockmanLink: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lockmanLink.automaticallyAdjustsScrollIndicatorInsets = false

        updateTextView()

    }
    

    func updateTextView() {
        
        let path = "https://www.lockman.org"
        let text = lockmanLink.text ?? ""
        let attributedString = NSAttributedString.makeHyperLink(for: path, in: text, as: "www.lockman.org")
        let font = lockmanLink.font
        
        lockmanLink.attributedText = attributedString
        lockmanLink.font = font
        
    }
}
