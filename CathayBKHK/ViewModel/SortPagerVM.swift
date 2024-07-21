//
//  SortPagerStore.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation
import ComposableArchitecture

struct SortPagerVM: Reducer {
    
    init() {}
    
    struct State: Equatable {
        var sorts: [SortPagerParams]
        var selectedPage: Int? = nil
        
        init(sorts: [SortPagerParams] = [], selectedPage: Int? = nil) {
            self.sorts = sorts
            self.selectedPage = selectedPage
        }
    }
    
    enum Action {
        case configure([SortPagerParams])
        case didSelectPageAt(Int)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .configure(sorts):
                state.sorts = sorts
                return .none
            case let .didSelectPageAt(page):
                state.selectedPage = page
                return .none
            }
        }
    }
}

