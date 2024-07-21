//
//  Friend.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/2.
//

import Foundation

/**
 {
   "response": [
     {
       "name": "蔡國泰",
       "kokoid": "Mike"
     }
   ]
 }
 */
struct UserEnvelope: Decodable {
    
    let users: [User]
    
    private enum CodingKeys: String, CodingKey {
        case users = "response"
    }
}

struct User: Codable, Equatable {
    
    var name: String
    var kokoID: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case kokoID = "kokoid"
    }
}


