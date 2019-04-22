

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
        let topBorder: CALayer = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: leaderBoardTableView.frame.size.width, height: 1)
        topBorder.backgroundColor = UIColor.purple.cgColor
        leaderBoardTableView.layer.addSublayer(topBorder)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(selectedLeaderBoard){
        case .GeoLeaderboard:
            let cell = Bundle.main.loadNibNamed("RankedUserTableViewCell", owner: self, options: nil)?.first as! RankedUserTableViewCell
            cell.userNameLabel.text = "Local Top User"
            cell.userPointsLabel.text = "42"
            cell.userRankLabel.text = String(indexPath.row+1)
            return cell
        case .TotalLeaderBoard:
            let cell = Bundle.main.loadNibNamed("RankedUserTableViewCell", owner: self, options: nil)?.first as! RankedUserTableViewCell
            cell.userNameLabel.text = "Top Global User"
            cell.userPointsLabel.text = "42"
            cell.userRankLabel.text = String(indexPath.row+1)
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
