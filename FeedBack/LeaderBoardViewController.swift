import UIKit
import Firebase
import FirebaseUI

enum LeaderBoardTypes{
    case GeoLeaderboard, TotalLeaderBoard
}

class LeaderBoardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate{

    @IBOutlet weak var typeOfLeaderBoardPickerView: UIPickerView!
    @IBOutlet weak var leaderBoardTableView: UITableView!
    @IBOutlet weak var selectionUIView: UIView!
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    var currentUser = Auth.auth().currentUser
    let leaderBoardTypes = [LeaderBoardTypes.GeoLeaderboard, LeaderBoardTypes.TotalLeaderBoard]
    var selectedLeaderBoard = LeaderBoardTypes.TotalLeaderBoard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        ref = Database.database().reference(withPath: usersPath)
        leaderBoardTableView.delegate = self
        setViewBorders()
    }
    
    private func setupPickerView(){
        typeOfLeaderBoardPickerView.dataSource = self
        typeOfLeaderBoardPickerView.delegate = self
    }
    
    func setDataSource(){
        switch(selectedLeaderBoard){
        case .GeoLeaderboard:
            dataSource = FUITableViewDataSource(query: getQuery(), populateCell: { (tableView, indexPath, snapshot) -> UITableViewCell in
                let cell = Bundle.main.loadNibNamed("RankedUserTableViewCell", owner: self, options: nil)?.first as! RankedUserTableViewCell
                guard let user = User(snapshot: snapshot) else { return cell }
                let storageReference = Storage.storage().reference()
                let profileImageRef = storageReference.child(usersPath).child(user.uniqueId).child("\(user.uniqueId)-profileImage.jpg")
                let placeholderImage = UIImage(named: "user.png")
                cell.userAvatar.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
                cell.userAvatar.setRounded()
                cell.userNameLabel.text = user.userName
                cell.uniqueUserId = user.uniqueId
                return cell
            })
            dataSource?.bind(to: leaderBoardTableView)
        case .TotalLeaderBoard:
            dataSource = FUITableViewDataSource(query: getQuery(), populateCell: { (tableView, indexPath, snapshot) -> UITableViewCell in
                let cell = Bundle.main.loadNibNamed("RankedUserTableViewCell", owner: self, options: nil)?.first as! RankedUserTableViewCell
                guard let user = User(snapshot: snapshot) else { return cell }
                let storageReference = Storage.storage().reference()
                let profileImageRef = storageReference.child(usersPath).child(user.uniqueId).child("\(user.uniqueId)-profileImage.jpg")
                let placeholderImage = UIImage(named: "user.png")
                cell.userAvatar.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
                cell.userAvatar.setRounded()
                cell.userNameLabel.text = user.userName
                cell.uniqueUserId = user.uniqueId
                cell.userPointsLabel.text = String(user.level)
                
                return cell
            })
            dataSource?.bind(to: leaderBoardTableView)
        }
        
        
    }
    
    func getQuery() -> DatabaseQuery {
        return self.ref.queryOrdered(byChild: levelPath)
        //return self.ref.queryOrdered(byChild: userNamePath)
        //queryOrdered(byChild: userNamePath).queryStarting(atValue: searchInput)
    }
    
    private func setViewBorders(){
        let bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: selectionUIView.frame.size.height+2, width: selectionUIView.frame.size.width, height: 2)
        bottomBorder.backgroundColor = UIColor.purple.cgColor
        selectionUIView.layer.addSublayer(bottomBorder)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leaderBoardTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(leaderBoardTypes[row]){
            case .GeoLeaderboard:
                return "Local"
            case .TotalLeaderBoard:
                return "Global"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(leaderBoardTypes[row]){
            case .GeoLeaderboard:
                selectedLeaderBoard = .GeoLeaderboard
            case .TotalLeaderBoard:
                selectedLeaderBoard = .TotalLeaderBoard
        }
        setDataSource()
        leaderBoardTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
