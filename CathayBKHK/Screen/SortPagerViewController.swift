//
//  SortPagerViewController.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit
import ComposableArchitecture
import Combine


final class SortPagerViewController: UIViewController {
    
    let store = Store(initialState: SortPagerVM.State(), reducer: { SortPagerVM() })
    private lazy var viewStore = ViewStore(store, observe: { $0 })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        bindingUI()
        bindingStyle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        indicatorView.cornerRadius = indicatorView.frame.height / 2
    }
    
    private func bindingStyle() {
        view.backgroundColor = .background1
        view.clipsToBounds = false
        
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
    }
    
    private func bindingUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.register(SortPagerCell.self, forCellWithReuseIdentifier: "SortPagerCell")
        
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35)
        indicatorLeadingConstraint?.isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func binding() {
        viewStore.publisher
            .sorts
            .sink { [weak self] sorts in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        viewStore.publisher
            .selectedPage
            .compactMap { $0 }
            .removeDuplicates()
            .sink { [weak self] page in
                self?.pinSelectedIndicator(toPage: page, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func pinSelectedIndicator(toPage page: Int, animated: Bool) {
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            if let cell = collectionView.cellForItem(at: indexPath) {
                let offset = cell.frame.center.x - indicatorView.frame.width / 2 + 32
                indicatorLeadingConstraint?.constant = offset
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // MARK: - Private Properties
    private var indicatorLeadingConstraint: NSLayoutConstraint?
    
    private let scrollView = UIScrollView()
    private var cancellables: [AnyCancellable] = []
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let indicatorView = UIView()
        .then {
            $0.backgroundColor = .primaryTintColor
        }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SortPagerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = viewStore.sorts[indexPath.item]
        return CGSize(width: data.title.size(forFont: .medium(size: 13), maxWidth: 100).width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        store.send(.didSelectPageAt(indexPath.item))
    }
}

// MARK: - UICollectionViewDataSource
extension SortPagerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewStore.sorts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortPagerCell", for: indexPath) as! SortPagerCell
        cell.populate(sort: viewStore.sorts[indexPath.item])
        
        return cell
    }
}

