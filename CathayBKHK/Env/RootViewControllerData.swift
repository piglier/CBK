//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation

typealias RootViewControllerIndex = Int

enum RootViewControllerData: Equatable {
    case wallets
    case friends
    case home
    case management
    case setting
}

enum TabBarItem: Equatable {
    case wallets(index: RootViewControllerIndex)
    case friends(index: RootViewControllerIndex)
    case home(index: RootViewControllerIndex)
    case management(index: RootViewControllerIndex)
    case setting(index: RootViewControllerIndex)
}

struct TabBarItemsData: Equatable {
    public let items: [TabBarItem]
    
    public init(items: [TabBarItem]) {
        self.items = items
    }
}
