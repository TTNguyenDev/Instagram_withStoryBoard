//
//  TabSwitcher.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Home: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView1: UITableView!
    
    var posts = [Posts]()
    var users = [Users]()
    
    fileprivate func loadPost() {
        let size = CGSize(width: 50, height: 50)
        let indicatorType = NVActivityIndicatorType.init(rawValue: 26)
        
        startAnimating(size, message: "Loading...", messageFont: UIFont.systemFont(ofSize: 15), type: indicatorType, color: .orange, padding: 2, displayTimeThreshold: 2, minimumDisplayTime: 2, backgroundColor: .white, textColor: .orange, fadeInAnimation: nil)
        
        Api.feed.loadPostId(completion: { (newPost) in
            self.fetchUser(uid: newPost.uid!, completed: {
                self.posts.append(newPost)
                self.stopAnimating()
                self.tableView1.reloadData()
            })
        }) {
            self.stopAnimating()
            CustomAlert.showAlert(withMessage: "No post to show")
        }
    }
    
    fileprivate func fetchUser(uid: String,completed: @escaping () -> Void) {
        Api.user.observe(withID: uid) { (user) in
            self.users.append(user)
            completed()
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        posts.removeAll()
        users.removeAll()
        loadPost()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

extension Home: UITableViewDataSource {
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
}

