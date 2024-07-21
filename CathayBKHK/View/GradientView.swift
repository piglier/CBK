//
//  GradientView.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit

class GradientView: View {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    var colors: [UIColor] = [] {
        didSet {
            guard colors != oldValue else { return }
            updateColors()
        }
    }
    
    var locations: [CGFloat] = [] {
        didSet {
            gradientLayer.locations = locations as [NSNumber]
        }
    }
    
    var startPoint: CGPoint {
        get { return gradientLayer.startPoint }
        set { gradientLayer.startPoint = newValue }
    }
    
    var endPoint: CGPoint {
        get { return gradientLayer.endPoint }
        set { gradientLayer.endPoint = newValue }
    }
    
    override func traitCollectionChanged(_ previousTraitCollection: UITraitCollection) {
        updateColors()
    }
    
    private func updateColors() {
        gradientLayer.colors = colors.map {
            $0.resolvedColor(with: traitCollection).cgColor
        }
    }
}

