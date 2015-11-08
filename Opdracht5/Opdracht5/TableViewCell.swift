//
//  TableViewCell.swift
//  Opdracht5
//
//  Created by Informatica Haarlem on 15-10-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var DetailImage: UIImageView!
    @IBOutlet weak var FavoriteStar: UIImageView!
    @IBOutlet weak var LikeButton: UIButton!
    @IBOutlet weak var DislikeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
