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
    
    fileprivate func fetchUsers() {
        Api.user.observeAllUsers { (newUser) in
            self.users.append(newUser)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchUsers()
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
