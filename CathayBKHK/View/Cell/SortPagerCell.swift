//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit
import Combine
import ComposableArchitecture

class SortPagerCell: UICollectionViewCell {
    
    let store = Store(initialState: SortPagerCellVM.State(), reducer: { SortPagerCellVM() })
    private lazy var viewStore = ViewStore(store, observe: { $0 })
    private var cancellables: [AnyCancellable] = []
    
    let label = UILabel()
    let badge = WrapperView<UILabel>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        
        label.font = .medium(size: 13)
        label.textColor = .primaryLabel
        
        addSubview(badge)
        badge.backgroundColor = .softPink
        badge.contentView.font = .medium(size: 12)
        badge.contentView.textColor = .white
        badge.inset = UIEdgeInsets(3.5)
        badge.contentView.textAlignment = .center
        
        viewStore.publisher.title
            .sink { title in
                self.label.text = title
            }
            .store(in: &cancellables)
        viewStore.publisher
            .number
            .sink { [weak self] number in
                self?.badge.contentView.text = number > 99 ? "99+" : "\(number)"
                self?.badge.alpha = number > 0 ? 1 : 0
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
        var badgeSize = badge.sizeThatFits(bounds.size)
        if badgeSize.width < badgeSize.height {
            badgeSize.width = badgeSize.height
        }
        badge.frame = CGRect(x: bounds.topRight.x, y: bounds.topRight.y - badgeSize.height/2, width: badgeSize.width, height: badgeSize.height)
        badge.cornerRadius = badge.frame.height / 2
    }
    
    func populate(sort: SortPagerParams) {
        store.send(.populate(sort))
    }
}

