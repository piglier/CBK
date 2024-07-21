//
//  Route.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation

enum Route {
    case userInfo
    case friend(page: Int)
    
    internal var requestProperties: (method: HttpMethod, path: String) {
        switch self {
        case .userInfo:
            return (.GET, "/man.json")
        case let .friend(page):
            return (.GET, "friend\(page).json")
        }
    }
}
