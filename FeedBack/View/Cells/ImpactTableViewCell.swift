//
//  ImpactTableViewCell.swift
//  FeedBack
//
//  Created by Julian on 23.04.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit

class ImpactTableViewCell: UITableViewCell {

    @IBOutlet weak var impactLabel: UILabel!
    @IBOutlet weak var impactNameLabel: UILabel!
    
    @IBOutlet weak var afterImpactLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
