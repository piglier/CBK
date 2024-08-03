//
//  CathayBKHKTests.swift
//  CathayBKHKTests
//
//  Created by 朱彥睿 on 2024/7/2.
//

import XCTest
import ComposableArchitecture
@testable import CathayBKHK

final class CathayBKHKTests: XCTestCase {
    
    
    func testProductionBaseUrl() {
        let expectedUrl = URL(string: "https://dimanyen.github.io")!
        XCTAssertEqual(ServerConfig.production.apiBaseUrl, expectedUrl, "Production base URL is incorrect.")
    }
    
    func testDevelopmentBaseUrl() {
        let expectedUrl = URL(string: "https://github.io")!
        XCTAssertEqual(ServerConfig.development.apiBaseUrl, expectedUrl, "Development base URL is incorrect.")
    }
    
    func testAddFriendPath() {
        let expectedPath = Route.userInfo.requestProperties.path
        XCTAssertEqual("/man.json", expectedPath, "AddFriend Path was Changed.")
    }
    
    func testFriendListV1Path() {
        let expectedPath = Route.friend(page: 1).requestProperties.path
        XCTAssertEqual("friend1.json", expectedPath, "FriendListV1 Path was Changed.")
    }
    
    func testFriendListV2Path() {
        let expectedPath = Route.friend(page: 2).requestProperties.path
        XCTAssertEqual("friend2.json", expectedPath, "FriendListV2 Path was Changed.")
    }
    
    func testFriendListWithInvitePath() {
        let expectedPath = Route.friend(page: 3).requestProperties.path
        XCTAssertEqual("friend3.json", expectedPath, "FriendListWithInvite Path was Changed.")
    }
    
    func testEmptyFriendList() {
        let expectedPath = Route.friend(page: 4).requestProperties.path
        XCTAssertEqual("friend4.json", expectedPath, "EmptyFriendList Path was Changed.")
    }
    
    func testCurrentUser() {
        NotificationCenter.default.addObserver(forName: .userUpdated, object: nil, queue: nil) { _ in
            self.friendViewStore.send(.currentUserUpdated)
        }
        let user = User(name: "蔡國泰", kokoID: "Mike")
        AppEnvironment.updateCurrentUser(user)
        NotificationCenter.default.post(name: .userUpdated, object: nil)
        let currentUser = friendViewStore.state.currentUser ?? User(name: "", kokoID: "")
        XCTAssertEqual(currentUser, user)
        NotificationCenter.default.removeObserver(self, name: .userUpdated, object: nil)
    }
    
    
    private let friendsStore = Store(initialState: FriendsVM.State(), reducer: { FriendsVM(episode: AppEnvironment.current.episode) })
    
    private lazy var friendViewStore = ViewStore(friendsStore, observe: { $0 })
    
//    private let sortStore = Store(initialState: SortPagerVM.State(), reducer: { SortPagerVM() })
//    
//    private lazy var sortViewStore = ViewStore(sortStore, observe: { $0 })
}
