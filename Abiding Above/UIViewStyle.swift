//
//  UIViewStyle.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 9/11/22.
//

import Foundation
import UIKit


extension UIView {
    
    func styleView() {
        
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        
    }
    
}
