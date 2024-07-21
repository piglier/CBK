//
//  Component.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit
import UIComponent

public extension Component {
    
    func shadow(color: UIColor = .black.withAlphaComponent(0.1), radius: CGFloat = 8) -> ViewUpdateComponent<ComponentViewComponent<ComponentView>> {
        view()
            .update {
                $0.layer.shadowColor = color.cgColor
                $0.layer.shadowOffset = CGSize(width: 0, height: radius / 2)
                $0.layer.shadowRadius = radius
                $0.layer.shadowOpacity = 1
            }
    }
    
    func capsule() -> ViewUpdateComponent<ComponentViewComponent<ComponentView>> {
        view()
            .update {
                $0.layer.cornerRadius = min($0.frame.height, $0.frame.width) / 2
            }
    }
}

