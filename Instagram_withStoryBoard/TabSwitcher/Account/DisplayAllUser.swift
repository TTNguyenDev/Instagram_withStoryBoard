//
//  DisplayAllUser.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 1/1/19.
//  Copyright © 2019 TT Nguyen. All rights reserved.
//

import UIKit

class DisplayAllUser: UIViewController {
    
    var users: [Users] = []
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate func fetchUsers(value: String) {
        Api.user.observeAllUsers { (newUser) in
            self.users.append(newUser)
            self.tableView.reloadData()
        }
//        users.removeAll()
//        tableView.reloadData()
//        Api.search.searchByString(searchValue: value) { (newUser) in
//            self.users.append(newUser)
//            self.tableView.reloadData()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchUsers(value: "")
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.placeholder = "Search Users"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
}

extension DisplayAllUser: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        fetchUsers(value: searchText)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
    }
    
    
    
    
    
}

extension DisplayAllUser: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
}
