//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation
import ComposableArchitecture

struct FriendListVM: Reducer {
    
    init() {}
    
    struct State: Equatable {
        var list: [Person]
        
        init(list: [Person] = []) {
            self.list = list
        }
    }
    
    enum Action {
        case configure([Person])
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .configure(person):
                state.list = person
                return .none
            }
        }
    }
}
