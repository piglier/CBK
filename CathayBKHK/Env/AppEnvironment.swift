//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation

struct AppEnvironment {
    
    fileprivate static var stack: [Environment] = [Environment()]
    
    // The most recent environment on the stack.
    static var current: Environment! {
        return stack.last
    }
    
    static func updateEpisoode(_ episode: InterviewEpisode) {
        replaceCurrentEnvironment(episode: episode)
    }
    
    static func updateCurrentUser(_ user: User) {
        replaceCurrentEnvironment(currentUser: user)
    }
    
    static func updateServerConfig(_ config: ServerConfigType) {
        let service = Service(serverConfig: config)
        replaceCurrentEnvironment(apiService: service)
    }
    
    static func replaceCurrentEnvironment(
        apiService: ServiceProtocol = AppEnvironment.current.apiService,
        currentUser: User? = AppEnvironment.current.currentUser,
        episode: InterviewEpisode = AppEnvironment.current.episode
    ) {
        replaceCurrentEnvironment(
            Environment(
                apiService: apiService,
                currentUser: currentUser,
                episode: episode
            )
        )
    }
    
    static func replaceCurrentEnvironment(_ env: Environment) {
        pushEnvironment(env)
        stack.remove(at: stack.count - 2)
    }
    
    /// Push a new environment onto the stack
    static func pushEnvironment(_ env: Environment) {
        stack.append(env)
    }
    
    static func pushEnvironment(
        apiService: ServiceProtocol = AppEnvironment.current.apiService,
        currentUser: User? = AppEnvironment.current.currentUser,
        episode: InterviewEpisode = AppEnvironment.current.episode
    ) {
        pushEnvironment(
            Environment(
                apiService: apiService,
                currentUser: currentUser,
                episode: episode
            )
        )
    }
    
    @discardableResult
    static func popEnvironment() -> Environment? {
        return stack.popLast()
    }
}
