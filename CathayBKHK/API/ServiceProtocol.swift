//
//  ServiceProtocol.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation

protocol ServiceProtocol {
    var serverConfig: ServerConfigType { get }
    
    init(serverConfig: ServerConfigType)
    
    func userInfo() async throws -> UserEnvelope
    
    func addFriend() async throws -> User?
    
    func friendList(page: Int) async throws -> [Person]
    
    func getFriendListV1() async throws -> [Person]
    
    func getFriendListV2() async throws -> [Person]
    
    func getFriendListWithInvite() async throws -> [Person]
    
    func getEmptyFriendList() async throws -> [Person]
    
}
