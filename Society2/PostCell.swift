//
//  PostCell.swift
//  Society2
//
//  Created by George Atuan on 9/4/16.
//  Copyright © 2016 George Atuan. All rights reserved.
//

import UIKit
import Alamofire


class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showImg: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showImg.clipsToBounds = true
        
    }
    
    func configureCell(post: Post, img: UIImage?) {
        self.post = post
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
    }
}
