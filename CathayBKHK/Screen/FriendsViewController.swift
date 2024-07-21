//
//  File.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit
import FloatingPanel
import ComposableArchitecture
import Combine

final class FriendsViewController: UIViewController {
    
    let store: StoreOf<FriendsVM>
    let viewStore: ViewStoreOf<FriendsVM>

    init(episode: InterviewEpisode) {
        self.store = Store(initialState: FriendsVM.State(), reducer: { FriendsVM(episode: episode) })
        self.viewStore = ViewStore(store, observe: { $0 })
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        bindingStyle()
        setupNavigationHeaderController()
        setupUserHeaderViewController()
        setupFriendListViewController()
        
        setupNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        store.send(.viewDidLoad)
    }
    
    private func bindingStyle() {
        view.backgroundColor = .white
    }
    
    private func binding() {
        viewStore.publisher.currentUser
            .removeDuplicates()
            .sink { [weak self] user in
                self?.userHeaderViewController?.populate(user: user)
            }
            .store(in: &cancellables)
        
        viewStore.publisher.friendList
            .removeDuplicates()
            .sink { [weak self] person in
                self?.friendListViewController?.populate(person: person)
            }
            .store(in: &cancellables)
        
        viewStore.publisher
            .showKeyboard
            .removeDuplicates()
            .sink { [weak self] showKeyboard in
                guard let self else { return }
                if showKeyboard {
                    self.friendListViewController?.collectionView.addGestureRecognizer(self.dismissKeyboardGesture)
                    self.searchBeginContraint?.isActive = true
                    self.searchBarEndContraint?.isActive = false
                    UIView.animate(withDuration: 0.3) {
                        self.userHeaderViewController?.view.alpha = 0
                        self.sortPagerViewController?.view.alpha = 0
                        self.view.layoutIfNeeded()
                    }
                } else {
                    self.friendListViewController?.collectionView.removeGestureRecognizer(self.dismissKeyboardGesture)
                    self.view.endEditing(true)
                    self.searchBeginContraint?.isActive = false
                    self.searchBarEndContraint?.isActive = true
                    UIView.animate(withDuration: 0.3) {
                        self.userHeaderViewController?.view.alpha = 1
                        self.sortPagerViewController?.view.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
            }
            .store(in: &cancellables)
        
        viewStore.publisher
            .filterList
            .compactMap { $0 }
            .removeDuplicates()
            .sink { [weak self] person in
                self?.friendListViewController?.store.send(.configure(person))
            }
            .store(in: &cancellables)
        
        viewStore.publisher
            .sorts
            .removeDuplicates()
            .sink { [weak self] sorts in
                self?.sortPagerViewController?.store.send(.configure(sorts))
            }
            .store(in: &cancellables)
        
        viewStore.publisher
            .isRefreshing
            .sink { [weak self] isRefreshing in
                isRefreshing ? self?.friendListViewController?.refreshControl.beginRefreshing() : self?.friendListViewController?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewStore.publisher
            .invitations
            .sink { [weak self] person in
                guard let self else { return }
                self.newInvitationViewController?.populate(person: person)
                self.newInvitationHeightContraint?.constant = person.isEmpty ? 0 : 130
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
        
        viewStore.publisher
            .isStacked
            .removeDuplicates()
            .sink { [weak self] isStacked in
                guard let self else { return }
                self.newInvitationViewController?.populate(person: viewStore.invitations, isStacked: isStacked)
                self.newInvitationHeightContraint?.constant = isStacked ? 130 : 200
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
        
        viewStore.publisher
            .searchText
            .sink { [weak self] text in
                self?.friendsSearchViewController?.searchBar.text = text
            }
            .store(in: &cancellables)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: .userUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.store.send(.currentUserUpdated)
        }
    }
    
    private func setupNavigationHeaderController() {
        let vc = FriendsNavigationHeaderController()
        let fpc = FloatingPanelController()
        fpc.layout = NavigationHeaderPanelLayout()
        fpc.addPanel(toParent: self)
        fpc.panGestureRecognizer.isEnabled = false
        fpc.surfaceView.appearance.shadows = []
        fpc.surfaceView.grabberHandle.alpha = 0
        fpc.set(contentViewController: vc)
        
        navigationHeaderViewController = vc
    }
    
    private func setupUserHeaderViewController() {
        guard let navigationHeaderViewController else { return }
        let vc = UserHeaderViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: navigationHeaderViewController.view.bottomAnchor).isActive = true
        vc.view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        didMove(toParent: self)
        
        userHeaderViewController = vc
    }
    
    private func setupSortPagerViewController() {
        guard let newInvitationViewController else { return }
        let vc = SortPagerViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: newInvitationViewController.view.bottomAnchor).isActive = true
        vc.view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        didMove(toParent: self)
        
        sortPagerViewController = vc
    }
    
    private func setupFriendsSearchViewController() {
        guard AppEnvironment.current.episode != .episode1 else { return }
        guard let sortPagerViewController, let navigationHeaderViewController else { return }
        let vc = FriendsSearchViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        searchBarEndContraint = vc.view.topAnchor.constraint(equalTo: sortPagerViewController.view.bottomAnchor)
        searchBarEndContraint?.isActive = true
        searchBeginContraint = vc.view.topAnchor.constraint(equalTo: navigationHeaderViewController.view.bottomAnchor)
        vc.view.heightAnchor.constraint(equalToConstant: 61).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        friendsSearchViewController = vc
        friendsSearchViewController?.delegate = self
    }
    
    private func setupFriendListViewController() {
        let vc = FriendsListViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        if let view = (friendsSearchViewController ?? userHeaderViewController)?.view {
            vc.view.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54).isActive = true
        
        friendListViewController = vc
        friendListViewController?.delegate = self
    }
    
    private func setupNewInvitationViewController() {
        guard let userHeaderViewController else { return }
        let vc = NewInvitationViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: userHeaderViewController.view.bottomAnchor).isActive = true
        newInvitationHeightContraint = vc.view.heightAnchor.constraint(equalToConstant: 0)
        newInvitationHeightContraint?.isActive = true
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        didMove(toParent: self)
        
        newInvitationViewController = vc
        newInvitationViewController?.delegate = self
    }
    
    private func removePreviousConstraints() {
        let vcs = [self.userHeaderViewController, self.navigationHeaderViewController, self.sortPagerViewController, self.friendListViewController, friendsSearchViewController]
        for vc in vcs {
            if let vc = vc {
                vc.view.removeFromSuperview()
                vc.removeFromParent()
            }
        }
    }

    @objc private func dismissKeyboard(ges: UITapGestureRecognizer) {
        store.send(.searchBarEndEditing)
    }
    
    // MARK: - Private Properties
    private weak var userHeaderViewController: UserHeaderViewController?
    private weak var navigationHeaderViewController: FriendsNavigationHeaderController?
    private weak var sortPagerViewController: SortPagerViewController?
    private weak var newInvitationViewController: NewInvitationViewController?
    private weak var friendListViewController: FriendsListViewController?
    private weak var friendsSearchViewController: FriendsSearchViewController?
    private var newInvitationHeightContraint: NSLayoutConstraint?
    private var searchBarEndContraint: NSLayoutConstraint?
    private var searchBeginContraint: NSLayoutConstraint?
    private let fpc = FloatingPanelController()
    private var cancellables: [AnyCancellable] = []
    private lazy var dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
}

// MARK:
extension FriendsViewController: FriendsSearchViewControllerDelegate {
    
    func searchBarDidEndEditing(_ searchBar: UISearchBar) {
        store.send(.searchBarEndEditing)
    }
    
    func searchBarDidBeginEditing(_ searchBar: UISearchBar) {
        store.send(.searchBarBeginEditing)
    }
    
    func searchBarTextDidChanged(_ searchBar: UISearchBar, searchText: String) {
        store.send(.searchTextChanged(searchText))
    }
    
}

// MARK: - FriendsListViewControllerDelegate
extension FriendsViewController: FriendsListViewControllerDelegate {
    
    func didScrollViewScroll(_ scrollView: UIScrollView) {
        guard viewStore.episode != .episode1 else { return }
        store.send(.searchBarEndEditing)
    }
    
    func didRefresh(_ refreshControl: UIRefreshControl) {
        store.send(.refresh)
        print("DidRefresh: \(viewStore.episode)")
        guard viewStore.episode == .episode2 else { return }
        updateEpisode(.episode3)
    }
    
    func updateEpisode(_ espisode: InterviewEpisode) {
        store.send(.updateEpisode(espisode))
        removePreviousConstraints()
        setupNavigationHeaderController()
        setupUserHeaderViewController()
        setupNewInvitationViewController()
        setupSortPagerViewController()
        setupFriendsSearchViewController()
        setupFriendListViewController()
    }
}

// MARK: - NewInvitationViewControllerDelegate
extension FriendsViewController: NewInvitationViewControllerDelegate {
    func didCardTapped(person: Person) {
        store.send(.invitationTapped(person))
    }
}

