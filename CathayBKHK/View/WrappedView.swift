//
//  WrappedView.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit

struct WrapperViewConfiguration<V: UIView> {
    // place to apply highlight state or animation to the TappableView
    public var onHighlightChanged: ((WrapperView<V>, Bool) -> Void)?

    // hook before the actual onTap is called
    public var didTap: ((WrapperView<V>) -> Void)?

    public init(onHighlightChanged: ((WrapperView<V>, Bool) -> Void)? = nil, didTap: ((WrapperView<V>) -> Void)? = nil) {
        self.onHighlightChanged = onHighlightChanged
        self.didTap = didTap
    }
}

class WrapperView<V: UIView>: View {
    
    public var configuration: WrapperViewConfiguration<V>? = WrapperViewConfiguration(
        onHighlightChanged: { view, isHighlighted in
            UIView.animate(withDuration: 0.2) {
                let scale = isHighlighted ? 0.96 : 1
                view.transform = .identity.scaledBy(x: scale, y: scale)
            }
        }
    )
    
    public private(set) lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
    
    open var contentView: V
    
    public var isHighlighted: Bool = false {
        didSet {
            guard isHighlighted != oldValue else { return }
            guard isHighlighted != oldValue else { return }
            configuration?.onHighlightChanged?(self, isHighlighted)
        }
    }

    public var inset: UIEdgeInsets = .zero {
        didSet {
            guard inset != oldValue else { return }
            setNeedsLayout()
        }
    }
    
    public var onTap: ((WrapperView<V>) -> Void)? {
        didSet {
            if onTap != nil {
                addGestureRecognizer(tapGestureRecognizer)
            } else {
                removeGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    public init() {
        contentView = V()
        super.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc open func didTap() {
        configuration?.didTap?(self)
        onTap?(self)
    }
    
    open override var intrinsicContentSize: CGSize {
        let size = contentView.intrinsicContentSize
        return CGSize(
            width: size.width + inset.left + inset.right,
            height: size.height + inset.top + inset.bottom
        )
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        addSubview(contentView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds.inset(by: inset)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let fixedSize = CGSize(width: size.width - inset.left - inset.right, height: size.height - inset.top - inset.bottom)
        let fitSize = contentView.sizeThatFits(fixedSize)
        return CGSize(width: fitSize.width + inset.left + inset.right, height: fitSize.height + inset.top + inset.bottom)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isHighlighted = true
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
    }
}

