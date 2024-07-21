//
//  FriendListCellStore.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation
import ComposableArchitecture

struct FriendListCellVM: Reducer {
    
    init() {}
    
    struct State: Equatable {
        
        var name: String
        var isTop: Bool
        var status: Int
        
        init(name: String = "", isTop: Bool = false, status: Int = 0) {
            self.name = name
            self.isTop = isTop
            self.status = status
        }
    }
    
    enum Action {
        case populate(Person)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .populate(person):
                state.isTop = person.isTop
                state.name = person.name
                state.status = person.status
                return .none
            }
        }
    }
}



