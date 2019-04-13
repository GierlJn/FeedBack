

import UIKit

class CharityTableViewCell: UITableViewCell {

    @IBOutlet weak var charityName: UILabel!
    @IBOutlet weak var charityLogo: UIImageView!
    
    @IBOutlet weak var informationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
