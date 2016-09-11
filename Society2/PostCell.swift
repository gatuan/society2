//
//  PostCell.swift
//  Society2
//
//  Created by George Atuan on 9/4/16.
//  Copyright © 2016 George Atuan. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showImg: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showImg.clipsToBounds = true
        
    }
    
    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.descriptionTxt.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"

        if post.imageUrl != nil {
            
            if img != nil {
                self.showImg.image = img
            } else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.showImg.image = img
                        NewsVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    } 
                })
            }
        } else {
            self.showImg.hidden = true
        }
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "heart_empty2")
            } else {
                self.likeImage.image = UIImage(named: "heart_full2")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "heart_full2")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "heart_empty2")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
        })
    }
}
