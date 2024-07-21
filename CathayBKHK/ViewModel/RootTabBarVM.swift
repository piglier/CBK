//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation
import ComposableArchitecture

struct RootTabBarVM: Reducer {
    
    init() {}
    
    struct State: Equatable {
        var tabBarItemsData: TabBarItemsData = TabBarItemsData(items: [])
        var viewControllers: [RootViewControllerData] = []
        var selectedIndex: Int = 0
        var currentUser: User? = nil
        
        
        init() {}
    }
    
    enum Action {
        case viewDidLoad
        case tabBarItemsData(TabBarItemsData)
        case viewControllers([RootViewControllerData])
        case selectedIndex(Int)
        case loginResponse(TaskResult<User?>)
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewDidLoad:
                return .concatenate(
                    .send(.tabBarItemsData(tabData())),
                    .send(.viewControllers([.wallets, .friends, .home, .management, .setting])),
                    .send(.selectedIndex(1)),
                    .run { send in
                        await send(.loginResponse(TaskResult { try await AppEnvironment.current.apiService.addFriend() }))
                    }
                )
            case let .tabBarItemsData(tabBarItemData):
                state.tabBarItemsData = tabBarItemData
                return .none
            case let .viewControllers(viewControllersData):
                state.viewControllers = viewControllersData
                return .none
            case let .selectedIndex(selectedIndex):
                state.selectedIndex = selectedIndex
                return .none
            case let .loginResponse(.success(user)):
                state.currentUser = user
                return .none
            case .loginResponse(.failure):
                return .none
            }
        }
    }
}

private func tabData() -> TabBarItemsData {
    let items: [TabBarItem] = [
        .wallets(index: 0),
        .friends(index: 1),
        .home(index: 2),
        .management(index: 3),
        .setting(index: 4)
    ]
    return TabBarItemsData(items: items)
}
