//
//  FriendsViewModel.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/2.
//

import Foundation
import ComposableArchitecture


struct FriendsVM: Reducer {
  
    init(episode: InterviewEpisode) {
        self.episode = episode
    }
    
    struct State: Equatable {
        var currentUser: User?
        var friendList: [Person] = []
        var invitations: [Person] = []
        var showKeyboard: Bool = false
        var filterList: [Person]? = nil
        var isRefreshing: Bool = false
        var isStacked: Bool = true
        var sorts: [SortPagerParams] = []
        var disableSearchbar: Bool = false
        var searchText: String? = nil
        var episode: InterviewEpisode = .episode1
        
        init() {}
    }
    
    enum Action {
        case currentUserUpdated
        case viewDidLoad
        case friendListResponse(TaskResult<[Person]>)
        case searchBarBeginEditing
        case searchBarEndEditing
        case searchTextChanged(String)
        case refresh
        case invitationTapped(Person)
        case createSortButtons
        case updateEpisode(InterviewEpisode)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .currentUserUpdated:
                state.currentUser = AppEnvironment.current.currentUser
                return .none
            case .viewDidLoad:
                switch state.episode {
                case .episode1:
                    return .merge(
                        .run { await $0(.friendListResponse(TaskResult { try await AppEnvironment.current.apiService.getEmptyFriendList() })) },
                        .send(.createSortButtons)
                    )
                case .episode2:
                    return .merge(
                        .run { await $0(.friendListResponse(TaskResult { try await
                            AppEnvironment.current.apiService.getFriendListV1()
                        }))},
                        .run { await $0(.friendListResponse(TaskResult { try await
                            AppEnvironment.current.apiService.getFriendListV2()
                        }))},
                        .send(.createSortButtons)
                    )
                case .episode3:
                    return .merge(
                        .run { await $0(.friendListResponse(TaskResult { try await
                            AppEnvironment.current.apiService.getFriendListWithInvite()
                        })) },
                        .send(.createSortButtons)
                    )
                }
                
            case let .friendListResponse(.success(person)):
                switch state.episode {
                case .episode1:
                    let merged = mergePersons(previous: state.friendList, new: person)
                    state.friendList = merged
                    state.isRefreshing = false
                    state.sorts = [
                        SortPagerParams(title: "好友", badgeNumber: merged.filter({ $0.status == 2 }).count ),
                        SortPagerParams(title: "聊天", badgeNumber: 100)
                    ]
                    state.disableSearchbar = true
                case .episode2:
                    let merged = mergePersons(previous: state.friendList, new: person)
                    state.friendList = merged
                    state.isRefreshing = false
                    state.sorts = [
                        SortPagerParams(title: "好友", badgeNumber: merged.filter({ $0.status == 2 }).count ),
                        SortPagerParams(title: "聊天", badgeNumber: 100)
                    ]
                case .episode3:
                    state.friendList = []
                    let merged = mergePersons(previous: state.friendList, new: person)
                    state.friendList = merged.filter { $0.status != 2 }
                    state.invitations = merged.filter { $0.status == 2 }
                    state.isRefreshing = false
                    state.sorts = [
                        SortPagerParams(title: "好友", badgeNumber: merged.filter({ $0.status == 2 }).count ),
                        SortPagerParams(title: "聊天", badgeNumber: 100)
                    ]
                    
                }
                return .none
            case .friendListResponse(.failure):
                state.isRefreshing = false
                return .none
            case .searchBarBeginEditing:
                state.showKeyboard = true
                return .none
            case .searchBarEndEditing:
                state.showKeyboard = false
                return .none
            case let .searchTextChanged(query):
                state.searchText = query
                if query.isEmpty {
                    state.filterList = state.friendList
                } else {
                    let filtered = state.friendList.filter { $0.name.contains(query) }
                    state.filterList = filtered
                }
                return .none
            case .refresh:
                state.filterList = nil
                state.friendList = []
                state.isRefreshing = true
                state.searchText = nil
                return .send(.viewDidLoad)
            case .invitationTapped:
                state.isStacked.toggle()
                return .none
            case .createSortButtons:
                state.sorts = [
                    SortPagerParams(title: "好友", badgeNumber: 0),
                    SortPagerParams(title: "聊天", badgeNumber: 0)
                ]
                return .none
            case let .updateEpisode(newEpisode):
                state.filterList = nil
                state.friendList = []
                state.isRefreshing = true
                state.searchText = nil
                state.episode = newEpisode
                AppEnvironment.updateEpisoode(newEpisode)
                return .send(.viewDidLoad)
            }
        }
    }
    
    
    private func mergePersons(previous previousPerson: [Person], new newPerson: [Person]) -> [Person] {

        let result = previousPerson.merge(newPerson, on: { $0.fid == $1.fid }) { a, b in
            guard let first = Int(a.updateDate.replacingOccurrences(of: "/", with: "")),
                  let last = Int(b.updateDate.replacingOccurrences(of: "/", with: "")) else {
                return a
            }
            
            return first < last ? b : a
        }
        
        return result
    }
    
    // MARK: - Private Properties
    private var episode: InterviewEpisode
}
