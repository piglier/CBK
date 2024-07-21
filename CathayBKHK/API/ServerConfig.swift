//
//  ServerConfigType.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation

protocol ServerConfigType {
    var apiBaseUrl: URL { get }
}

struct ServerConfig: ServerConfigType {
    
    var apiBaseUrl: URL
    
    static let production: ServerConfigType = ServerConfig(
        apiBaseUrl: URL(string: "https://dimanyen.github.io")!
    )
    
    static let development: ServerConfigType = ServerConfig(
        apiBaseUrl: URL(string: "https://github.io")!
    )
}

