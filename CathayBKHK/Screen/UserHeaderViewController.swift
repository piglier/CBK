//
//  UserHeaderViewController.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit
import ComposableArchitecture
import Combine

final class UserHeaderViewController: UIViewController {
    
    private let store: StoreOf<UserHeaderVM> = Store(initialState: UserHeaderVM.State(), reducer: { UserHeaderVM() })
    private lazy var viewStore: ViewStoreOf<UserHeaderVM> = ViewStore(store, observe: { $0 })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background1
        
        view.addSubview(avatorView)
        
        avatorView.translatesAutoresizingMaskIntoConstraints = false
        avatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        avatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        avatorView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        avatorView.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(subtitleLabel)
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        subtitleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        view.addSubview(arrowImage)
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.leadingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        arrowImage.centerYAnchor.constraint(equalTo: subtitleLabel.centerYAnchor).isActive = true
        arrowImage.heightAnchor.constraint(equalToConstant: 18).isActive = true
        arrowImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        view.addSubview(circleImage)
        circleImage.translatesAutoresizingMaskIntoConstraints = false
        circleImage.leadingAnchor.constraint(equalTo: arrowImage.trailingAnchor, constant: 15).isActive = true
        circleImage.centerYAnchor.constraint(equalTo: arrowImage.centerYAnchor).isActive = true
        circleImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        circleImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        binding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circleImage.cornerRadius = circleImage.frame.height / 2
    }
    
    private func binding() {
        
        let stream = viewStore.publisher
            .user
            .compactMap { $0 }
            .share()
        
        stream
            .map(\.name)
            .removeDuplicates()
            .sink { [weak self] name in
                self?.nameLabel.text = name
            }
            .store(in: &cancellables)
        stream.map(\.kokoID)
            .removeDuplicates()
            .sink { [weak self] kokoID in
                self?.subtitleLabel.text = "KOKO ID：\(kokoID)"
            }
            .store(in: &cancellables)
        
        viewStore.publisher.user
            .removeDuplicates()
            .sink { [weak self] user in
                self?.circleImage.isHidden = user != nil
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private properties
    
    private let avatorView = UIImageView()
        .then {
            $0.image = UIImage(named: "img_friends_female_default")
        }
    
    private let stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 8
        }
    
    let nameLabel = UILabel()
        .then {
            $0.text = ""
            $0.textColor = .primaryLabel
            $0.font = .medium(size: 17)
        }
    
    private let subtitleLabel = UILabel()
        .then {
            $0.text = "設定 KOKO ID"
            $0.textColor = .primaryLabel
            $0.font = .regular(size: 13)
        }
    
    private let arrowImage = UIImageView()
        .then {
            $0.image = UIImage(named: "ic_grey_arrow_right")
        }
    
    private let circleImage = UIView()
        .then {
            $0.backgroundColor = .primaryTintColor
        }
    
    private var cancellables: [AnyCancellable] = []
}

extension UserHeaderViewController {
    func populate(user: User?) {
        store.send(.configure(user))
    }
}

