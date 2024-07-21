//
//  SortPagerCellStore.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import ComposableArchitecture

struct SortPagerCellVM: Reducer {
    
    init() {}
    
    struct State: Equatable {
        var title: String
        var number: Int
        
        init(title: String = "", number: Int = 0) {
            self.title = title
            self.number = number
        }
    }
    
    enum Action {
        case populate(SortPagerParams)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .populate(params):
                state.number = params.badgeNumber
                state.title = params.title
                return .none
            }
        }
    }
}
