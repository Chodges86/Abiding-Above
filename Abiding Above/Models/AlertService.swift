//
//  AlertService.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 12/14/21.
//

import Foundation
import UIKit

struct AlertService {
    
    func createAlert(_ message: String, _ buttonTitle: String) -> AlertViewController {
        
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        
        alertVC.buttonTitle = buttonTitle
        alertVC.alertMessage = message
        
        return alertVC
    }
    
}
