

import UIKit

enum LeaderBoardTypes{
    case GeoLeaderboard, TotalLeaderBoard
}

class LeaderBoardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var typeOfLeaderBoardPickerView: UIPickerView!
    @IBOutlet weak var leaderBoardTableView: UITableView!
    @IBOutlet weak var selectionUIView: UIView!
    
    
    let leaderBoardTypes = [LeaderBoardTypes.GeoLeaderboard, LeaderBoardTypes.TotalLeaderBoard]
    var selectedLeaderBoard = LeaderBoardTypes.TotalLeaderBoard
    
    let sampleData = [
        User(userName: "Bill Gates", userLevel: 1900, userAvatar: UIImage(imageLiteralResourceName: "bill_gates.jpeg")),
        User(userName: "Warren Buffet", userLevel: 1500, userAvatar: UIImage(imageLiteralResourceName: "buffet.jpeg")),
        User(userName: "Mark Zuckerberg", userLevel: 1300, userAvatar: UIImage(imageLiteralResourceName: "zuckerberg.jpeg")),
        User(userName: "Paul Allen", userLevel: 1000, userAvatar: UIImage(imageLiteralResourceName: "paul_allen.jpeg"))
                      ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeaderBoard()
        setupLeaderBoardTableView()
        setViewBorders()
    }
    
    private func setupLeaderBoard(){
        typeOfLeaderBoardPickerView.dataSource = self
        typeOfLeaderBoardPickerView.delegate = self
    }
    
    private func setupLeaderBoardTableView(){
        leaderBoardTableView.dataSource = self
        leaderBoardTableView.delegate = self
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
                return "Leaderboard Local"
            case .TotalLeaderBoard:
                return "Leaderboard Global"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(leaderBoardTypes[row]){
            case .GeoLeaderboard:
                selectedLeaderBoard = .GeoLeaderboard
            case .TotalLeaderBoard:
                selectedLeaderBoard = .TotalLeaderBoard
        }
        leaderBoardTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(selectedLeaderBoard){
        case .GeoLeaderboard:
            let cell = Bundle.main.loadNibNamed("RankedUserTableViewCell", owner: self, options: nil)?.first as! RankedUserTableViewCell
            cell.userNameLabel.text = sampleData[indexPath.row].userName
            cell.userPointsLabel.text = String(sampleData[indexPath.row].userLevel)
            cell.userAvatar.image = sampleData[indexPath.row].userAvatar
            cell.userRankLabel.text = String(indexPath.row+1)
            return cell
        case .TotalLeaderBoard:
            let cell = Bundle.main.loadNibNamed("RankedUserTableViewCell", owner: self, options: nil)?.first as! RankedUserTableViewCell
            cell.userNameLabel.text = sampleData[indexPath.row].userName
            cell.userPointsLabel.text = String(sampleData[indexPath.row].userLevel)
            cell.userAvatar.image = sampleData[indexPath.row].userAvatar
            cell.userRankLabel.text = String(indexPath.row+1)
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
