//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//


struct SortPagerParams: Equatable {
    
    var title: String
    var badgeNumber: Int
    
    init(title: String, badgeNumber: Int) {
        self.title = title
        self.badgeNumber = badgeNumber
    }
}
