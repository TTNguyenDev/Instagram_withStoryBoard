//
//  Comment.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/23/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDataSource {
    
    var comments = [Comments]()
    var users = [Users]()
    var postId: String!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var commentText: UITextField!
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButton(_ sender: Any) {
        let commentRef = Api.comment.COMMENT_REF
        let newCommentId = commentRef.childByAutoId().key
        let newCommentRef = commentRef.child(newCommentId!)
        
        let currentId = Api.user.CURRENT_USER?.uid
        newCommentRef.setValue(["uid": currentId, "comment": commentText.text!]) { (error, refs) in
            if error != nil {
                CustomAlert.showError(withMessage:  (error?.localizedDescription)!)
                return
            }
            
            //recognize which post has comment
            let postComment = Api.post_comment.POST_COMMENT_REF.child(self.postId).child(newCommentId!)
            postComment.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    CustomAlert.showError(withMessage: (error?.localizedDescription)!)
                    return
                }
            })
            self.empty()
        }
    }
    
    fileprivate func empty() {
        commentText.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comments = comment
        cell.user = user
        return cell
    }
    
    fileprivate func loadComments() {
        Api.post_comment.POST_COMMENT_REF.child(self.postId).observe(.childAdded) { (snapShot) in
            Api.comment.observe(withKey: snapShot.key, completion: { (newComment) in
                self.fetchUser(uid: newComment.uid!, completed: {
                    self.comments.append(newComment)
                    self.tableView1.reloadData()
                })
            })
        }
    }
    
    fileprivate func fetchUser(uid: String,completed: @escaping () -> Void) {
        Api.user.observe(withID: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height - 40
            
            UIView.animate(withDuration: 0.3) {
                self.bottomConstraint.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc fileprivate func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func setupTableView() {
        tableView1.dataSource = self
        tableView1.estimatedRowHeight = 50
        tableView1.rowHeight = UITableView.automaticDimension
    }
    
    fileprivate func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadComments()
        setupNotification()
    }
}
