//
//  Account.swift
//  Instagram_withStoryBoard
//
//  Created by TT Nguyen on 11/22/18.
//  Copyright © 2018 TT Nguyen. All rights reserved.
//

import UIKit

class Account: UIViewController {
    
    var mPost: [Posts] = []
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func displayAllUserButton(_ sender: Any) {
        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        Api.auth.signOut(onFail: { (error) in
            CustomAlert.showError(withMessage: error)
        }) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func fetchPost() {
        Api.myPost.getPostFromServer(completion: { (post) in
            self.mPost.append(post)
            self.collectionView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchPost()
    }
}

extension Account: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ImageCell
        let post = mPost[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfile", for: indexPath) as! HeaderProfileCollectionReusableView
        headerViewCell.updateView()
        return headerViewCell
    }
}

extension Account: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 1 , height:  collectionView.frame.width / 3 - 1)
    }
}
