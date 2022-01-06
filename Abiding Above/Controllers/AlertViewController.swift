//
//  AlertViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 12/13/21.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    
    var buttonTitle = String()
    var alertMessage = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.layer.cornerRadius = 15
        
        actionButton.setTitle(buttonTitle, for: .normal)
        alertLabel.text = alertMessage
        
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
