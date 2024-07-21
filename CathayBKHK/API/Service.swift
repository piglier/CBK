//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

struct Service: ServiceProtocol {
    
    let serverConfig: ServerConfigType
    let monitor: ServiceMonitorProtocol
    
    init(serverConfig: ServerConfigType = ServerConfig.production) {
        self.serverConfig = serverConfig
        self.monitor = CompositeServiceMonitor(monitors: [ServiceMonitor()])
    }
    
    func userInfo() async throws -> UserEnvelope {
        try await request(.userInfo)
    }
    
    func addFriend() async throws -> User? {
        let envelope = try await userInfo()
        return envelope.users.first
    }
    
    func friendList(page: Int) async throws -> [Person] {
        let envelope: PersonEnvelope = try await request(.friend(page: page))
        return envelope.response
    }
    
    func getFriendListV1() async throws -> [Person] {
        try await friendList(page: 1)
    }
    
    func getFriendListV2() async throws -> [Person] {
        try await friendList(page: 2)
    }
    
    func getFriendListWithInvite() async throws -> [Person] {
        try await friendList(page: 3)
    }
    
    func getEmptyFriendList() async throws -> [Person] {
        try await friendList(page: 4)
    }
}

