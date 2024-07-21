//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit
import FloatingPanel

public final class NavigationHeaderPanelLayout: FloatingPanelLayout {
    
    public let anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring]
    
    public init(height: CGFloat = 44.0) {
        anchors = [.tip: FloatingPanelLayoutAnchor(absoluteInset: height, edge: .top, referenceGuide: .safeArea)]
    }
    
    public let position: FloatingPanelPosition = .top
    public let initialState: FloatingPanelState = .tip
    
    public func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0
    }
}
