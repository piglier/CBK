//
//  CathayBKHKTests.swift
//  CathayBKHKTests
//
//  Created by 朱彥睿 on 2024/7/2.
//

import XCTest
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
}
