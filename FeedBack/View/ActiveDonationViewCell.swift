//
//  ActiveDonationViewCell.swift
//  FeedBack
//
//  Created by Julian on 08.04.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit

class ActiveDonationViewCell: UITableViewCell {

    @IBOutlet weak var monthlyProgress: UIProgressView!
    @IBOutlet weak var charityAvatar: UIImageView!
    @IBOutlet weak var charityNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var statsInfoLabel: UILabel!
    @IBOutlet weak var statsSumLabel: UILabel!
    @IBOutlet weak var statsSumInNumbers: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
