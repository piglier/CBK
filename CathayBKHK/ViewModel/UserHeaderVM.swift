//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation
import ComposableArchitecture


struct UserHeaderVM: Reducer {
    
    init() {}
    
    struct State: Equatable {
        var user: User?
        
        init(user: User? = nil) {
            self.user = user
        }
    }
    
    enum Action {
        case configure(User?)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .configure(user):
                state.user = user
                return .none
            }
        }
    }
}
