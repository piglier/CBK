//
//  a.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit
import ComposableArchitecture
import Combine

final class RootTabBarController: UITabBarController {
    let store: StoreOf<RootTabBarVM>
    let viewStore: ViewStoreOf<RootTabBarVM>
    
    init() {
        self.store = Store(initialState: RootTabBarVM.State(), reducer: { RootTabBarVM() })
        self.viewStore = ViewStore(store, observe: { $0 })
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomTabBar()
        bindingStyle()
        binding()
        
        store.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func updateViewConstraints() {
        rootTabBar.translatesAutoresizingMaskIntoConstraints = false
        rootTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rootTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rootTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rootTabBar.heightAnchor.constraint(equalToConstant: view.safeAreaInsets.bottom + 54).isActive = true
        super.updateViewConstraints()
    }
    
    private func bindingStyle() {
        view.backgroundColor = .white
        rootTabBar.backgroundColor = .white
        tabBar.isHidden = true
    }
    
    private func binding() {
        viewStore.publisher.viewControllers
            .map { $0.map(RootTabBarController.viewController) }
            .map { $0.map(UINavigationController.init(rootViewController:)) }
            .sink { [weak self] viewControllers in
                self?.setViewControllers(viewControllers, animated: false)
            }
            .store(in: &cancellable)
        viewStore.publisher.tabBarItemsData
            .removeDuplicates()
            .sink { [weak self] tabBarItemsData in
                self?.setTabBarItemStyles()
            }
            .store(in: &cancellable)
        viewStore.publisher.selectedIndex
            .removeDuplicates()
            .sink { [weak self] selectedIndex in
                self?.selectedIndex = selectedIndex
                self?.setTabBarItemStyles()
            }
            .store(in: &cancellable)
        viewStore.publisher.currentUser
            .sink { user in
                guard let user else { return }
                AppEnvironment.updateCurrentUser(user)
                NotificationCenter.default.post(.init(name: .userUpdated))
            }
            .store(in: &cancellable)
    }
    
    private func setupCustomTabBar() {
        view.addSubview(rootTabBar)
        view.setNeedsUpdateConstraints()
    }
    
    private func setTabBarItemStyles() {
        rootTabBar.populate(tabBarItemsData: viewStore.tabBarItemsData)
    }
    
    fileprivate static func viewController(from viewControllerData: RootViewControllerData) -> UIViewController {
        switch viewControllerData {
        case .wallets:
            return UIViewController()
        case .friends:
            return FriendsViewController(episode: AppEnvironment.current.episode)
        case .home:
            return UIViewController()
        case .management:
            return UIViewController()
        case .setting:
            return UIViewController()
        }
    }
    
    // MARK: - Private properties
    private let rootTabBar = TabBarView()
    private var cancellable: [AnyCancellable] = []
    
    private var aces: String?
    
}

