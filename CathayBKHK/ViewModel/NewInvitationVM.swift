//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/7.
//

import Foundation
import ComposableArchitecture

struct NewInvitationVM: Reducer {
    
    init() {}
    
    struct State: Equatable {
        var invitations: [Person]
        var isStacked: Bool
        init(invitations: [Person] = [], isStacked: Bool = true) {
            self.invitations = invitations
            self.isStacked = isStacked
        }
    }
    
    enum Action {
        case configure([Person], stacked: Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .configure(person, stacked):
                state.invitations = person
                state.isStacked = stacked
                return .none
            }
        }
    }
}

