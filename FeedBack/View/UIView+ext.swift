

import Foundation
import UIKit



class ProfileSubView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBottomBorder()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBottomBorder()
    }
    
    func addBottomBorder(){
        let bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height+1, width: self.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.purple.cgColor
        self.layer.addSublayer(bottomBorder)
    }
}
