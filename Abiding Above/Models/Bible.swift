//
//  Bible.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 11/4/21.
//

import Foundation

struct Bible {
    
    struct PassageData: Decodable {
        var data: Passage
    }
    
    struct Passage: Decodable {
        var content: String
        var reference: String
        
    }
    
}
