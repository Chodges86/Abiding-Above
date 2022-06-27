//
//  NSAttributedStringExt.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 6/23/22.
//

import Foundation

extension NSAttributedString {
 
    static func makeHyperLink(for path: String, in string: String, as substring: String) -> NSAttributedString {
        
        let nsString = NSString(string: string)
        let subStringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: subStringRange)
        return attributedString
    }
}
