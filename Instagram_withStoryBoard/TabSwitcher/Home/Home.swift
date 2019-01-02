//
//  TabSwitcher.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit

class Home: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView1: UITableView!
    
    var posts = [Posts]()
    var users = [Users]()
    
    lazy var refresher: UIRefreshControl = {
        let refresherControl = UIRefreshControl()
        refresherControl.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        refresherControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return refresherControl
    }()
    
    
    @objc func reloadData() {
        self.refresher.endRefreshing()
        
    }
    
    fileprivate func loadPost() {
        indicator.startAnimating()
        Api.feed.loadPostId { (newPost) in
            self.fetchUser(uid: newPost.uid!, completed: {
                self.posts.append(newPost)
                self.indicator.stopAnimating()
                self.tableView1.reloadData()
            })
        }
    }
    
    fileprivate func fetchUser(uid: String,completed: @escaping () -> Void) {
        Api.user.observe(withID: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postID", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.homeVC = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue" {
            let commentVC = segue.destination as!CommentViewController
            let postId = sender  as! String
            commentVC.postId = postId
        }
    }
    
    fileprivate func setupTableView() {
        tableView1.rowHeight = UITableView.automaticDimension
        tableView1.estimatedRowHeight = 300
        tableView1.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        indicator.hidesWhenStopped = true
        loadPost()
        tableView1.refreshControl = refresher
    }
}

