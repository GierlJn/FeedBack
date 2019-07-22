//
//  AchievementCell.swift
//  FeedBack
//
//  Created by Julian on 15.04.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit

class AchievementCell: UICollectionViewCell {

    
    @IBOutlet weak var achievementImage: UIImageView!
    @IBOutlet weak var achievementTitle: UILabel!
    
    static let identifier = "achievementCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
