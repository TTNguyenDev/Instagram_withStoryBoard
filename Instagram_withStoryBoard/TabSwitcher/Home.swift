//
//  TabSwitcher.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class Home: UIViewController, UITableViewDataSource {
    
    var posts = [Posts]()
    
    @IBOutlet weak var tableView1: UITableView!
    
    fileprivate func loadPost() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(.clear)
        Database.database().reference().child("posts").observe(.childAdded) { (snapShot) in
            print(snapShot.value)
            if let dictionary = snapShot.value as? NSDictionary {
                let newPost = Posts.transformPostPhoto(dictionary: dictionary, key: snapShot.key)
//                self.fetchUser(uid: (Auth.auth().currentUser?.uid)!, completed: {
                    self.posts.append(newPost)
                    SVProgressHUD.dismiss()
                    self.tableView1.reloadData()
//                })
            }
        }
    }
    
//    fileprivate func fetchUser(uid: String,completed: @escaping () -> Void) {
//        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapShot) in
//            if let dictionary = snapShot.value as? NSDictionary {
//                let user = Users.transformUser(dictionary: dictionary)
//                self.users.append(user)
//                completed()
//            }
//        }
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadPost()
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postID", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView1.rowHeight = UITableView.automaticDimension
        tableView1.estimatedRowHeight = 300
//        tableView1.estimatedRowHeight = 521
//        tableView1.rowHeight = UITableView.automaticDimension
        tableView1.dataSource = self
        loadPost()

//
       
    

    }

}

