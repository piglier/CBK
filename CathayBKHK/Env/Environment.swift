//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation

struct Environment {
    
    let apiService: ServiceProtocol
    
    let currentUser: User?

    let episode: InterviewEpisode
    
    init(
        apiService: ServiceProtocol = Service(),
        currentUser: User? = nil,
        episode: InterviewEpisode = .episode1
    ) {
        self.apiService = apiService
        self.currentUser = currentUser
        self.episode = episode
    }
}
