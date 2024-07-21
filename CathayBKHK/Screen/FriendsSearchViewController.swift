//
//  FriendsSearchViewController.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit

protocol FriendsSearchViewControllerDelegate: AnyObject {
    func searchBarDidBeginEditing(_ searchBar: UISearchBar)
    func searchBarDidEndEditing(_ searchBar: UISearchBar)
    func searchBarTextDidChanged(_ searchBar: UISearchBar, searchText: String)
}

final class FriendsSearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    weak var delegate: FriendsSearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(addFriendImageView)
        addFriendImageView.translatesAutoresizingMaskIntoConstraints = false
        addFriendImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addFriendImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        addFriendImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        addFriendImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: addFriendImageView.leadingAnchor, constant: -15).isActive = true
        searchBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        searchBar.delegate = self
        searchBar.searchTextField.font = .regular(size: 14)
        searchBar.searchTextField.backgroundColor = .steel.withAlphaComponent(0.12)
        searchBar.placeholder = "想轉一筆給誰呢？"
        searchBar.searchTextField.font = .regular(size: 14)
        searchBar.searchBarStyle = .minimal
    }
    
    private let addFriendImageView = UIImageView(image: UIImage(named: "ic_pink_add_friend"))
}


// MARK: - UISearchBarDelegate
extension FriendsSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchBarTextDidChanged(searchBar, searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchBarDidEndEditing(searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        delegate?.searchBarDidEndEditing(searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.searchBarDidBeginEditing(searchBar)
    }
}

