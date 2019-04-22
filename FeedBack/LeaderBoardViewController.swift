

import UIKit

enum LeaderBoardTypes{
    case GeoLeaderboard, TotalLeaderBoard
}

class LeaderBoardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var typeOfLeaderBoardPickerView: UIPickerView!
    @IBOutlet weak var leaderBoardTableView: UITableView!
    
    let leaderBoardTypes = [LeaderBoardTypes.GeoLeaderboard, LeaderBoardTypes.TotalLeaderBoard]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeaderBoard()
        setupLeaderBoardTableView()
    }
    
    private func setupLeaderBoard(){
        typeOfLeaderBoardPickerView.dataSource = self
        typeOfLeaderBoardPickerView.delegate = self
    }
    
    private func setupLeaderBoardTableView(){
        leaderBoardTableView.dataSource = self
        leaderBoardTableView.delegate = self
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
                return "Top 10 Local"
            case .TotalLeaderBoard:
                return "Top 10 Global"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let rankedUsers = leaderBoardDataMockup["users"] as! [UserDataModel]
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RankedUserTableViewCell", owner: self, options: nil)?.first as! RankedUserTableViewCell
        //let rankedUsers = leaderBoardDataMockup["users"] as! [UserDataModel]
        cell.userNameLabel.text = "Arya Stark"
        cell.userPointsLabel.text = "123123"
        return cell
    }

}
