//
//  FriendsListViewController.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit
import ComposableArchitecture
import Combine


protocol FriendsListViewControllerDelegate: AnyObject {
    func didScrollViewScroll(_ scrollView: UIScrollView)
    func didRefresh(_ refreshControl: UIRefreshControl)
    func updateEpisode(_ espisode: InterviewEpisode)
}

final class FriendsListViewController: UIViewController {
    
    private enum Section: Hashable {
        case main
    }
    
    let refreshControl = UIRefreshControl()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let store: StoreOf<FriendListVM> = Store(initialState: FriendListVM.State(), reducer: { FriendListVM() })
    lazy var viewStore: ViewStoreOf<FriendListVM> = ViewStore(store, observe: { $0 })
    
    weak var delegate: FriendsListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingStyle()
        bindingUI()
        binding()
        
    }
    
    private func bindingStyle() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .clear
    }
    
    private func bindingUI() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .primaryTintColor
        refreshControl.transform = .identity.scaledBy(0.6)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "FriendListCell", bundle: nil), forCellWithReuseIdentifier: "FriendListCell")
        collectionView.refreshControl = refreshControl
        collectionView.backgroundView = emptyView
        emptyView.delegate = self
    }
    
    private func binding() {
        viewStore.publisher.list
            .removeDuplicates()
            .sink { [weak self] list in
                guard let self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<Section, Person>()
                snapshot.appendSections([.main])
                snapshot.appendItems(list, toSection: .main)
                self.dataSource.apply(snapshot, animatingDifferences: true)
                
                UIView.animate(withDuration: 0.2) {
                    self.emptyView.alpha = list.isEmpty ? 1 : 0
                }
            }
            .store(in: &cancellables)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @objc private func refresh() {
        delegate?.didRefresh(refreshControl)
    }
    
    // MARK: - Private properties
    private let emptyView = FriendEmptyView()
    private var cancellables: [AnyCancellable] = []
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Person>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
        cell.populate(person: itemIdentifier)
        return cell
    }
    
}

extension FriendsListViewController {
    
    func populate(person: [Person]) {
        store.send(.configure(person))
    }
}

// MARK: - UICollectionViewDelegate
extension FriendsListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScrollViewScroll(scrollView)
    }
}

// MARK: - FriendEmptyViewDelegate
extension FriendsListViewController: FriendEmptyViewDelegate {
    func updateEpisode(_ espisode: InterviewEpisode) {
        delegate?.updateEpisode(espisode)
    }
    
    func update() {
        delegate?.didRefresh(refreshControl)
    }
}
