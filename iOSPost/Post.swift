//
//  File.swift
//  iOSPost
//
//  Created by Bobba Kadush on 5/13/19.
//  Copyright © 2019 Bobba Kadush. All rights reserved.
//

import Foundation

class Post: Codable {
    let text: String
    let timestamp: Double
    let username: String
    
    init(text: String, timestamp: Double = Date().timeIntervalSince1970, username: String) {
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
}
