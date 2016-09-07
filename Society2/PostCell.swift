//
//  PostCell.swift
//  Society2
//
//  Created by George Atuan on 9/4/16.
//  Copyright © 2016 George Atuan. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showImg.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
