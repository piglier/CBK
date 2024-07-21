//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation


enum CurrentUserNotifications {
    static let userUpdated = "CurrentUserNotifications.userUpdated"
}

extension Notification.Name {
    
    static let userUpdated = Notification.Name(rawValue: CurrentUserNotifications.userUpdated)
}
