//
//  String+.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit

extension String {
    
    public func size(forFont font: UIFont, maxWidth width: CGFloat) -> CGSize {
        let constraintRect = CGSize(width: width, height: .zero)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.size
    }
}
