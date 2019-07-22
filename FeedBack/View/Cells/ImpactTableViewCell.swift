//
//  ImpactTableViewCell.swift
//  FeedBack
//
//  Created by Julian on 23.04.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit
import Firebase
class ImpactTableViewCell: UITableViewCell {

    @IBOutlet weak var impactLabel: UILabel!
    //@IBOutlet weak var impactNameLabel: UILabel!
    @IBOutlet weak var afterImpactLabel: UILabel!
    
    static let identifier = "ImpactTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(for donation: Donation){
        //impactNameLabel.text = donation.impactType.getimpactDescriptionStringBeforeValue()
        impactLabel.text = String(Int(Float(donation.impactAmount)!))
        afterImpactLabel.text = donation.impactType.getimpactDescriptionStringAfterValue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
