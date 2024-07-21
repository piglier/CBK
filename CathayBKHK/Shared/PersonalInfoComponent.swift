//
//  PersonalInfoComponent.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit
import UIComponent

struct PersonalInfoComponent: ComponentBuilder {
    
    var user: User?
    
    func build() -> Component {
        HStack {
            VStack(spacing: 8) {
                Text(user?.name ?? "", font: .medium(size: 17))
                    .textColor(.primaryLabel)
                HStack(alignItems: .center) {
                    if let user {
                        Text("KOKO ID：\(user.kokoID)", font: .regular(size: 13))
                            .textColor(.primaryLabel)
                    } else {
                        Text("設定KOKO ID", font: .regular(size: 13))
                            .textColor(.primaryLabel)
                    }
                    
                    Image("ic_grey_arrow_right")
                    if user == nil {
                        Space(width: 15)
                        Color(.primaryTintColor, radius: 5)
                            .size(width: 10, height: 10)
                    }
                }
                .tappableView {}
            }
            .flex()
            Image("img_friends_female_default")
                .tappableView {}
        }
        .inset(h: 30)
        .view()
        .backgroundColor(.background1)
    }
}

