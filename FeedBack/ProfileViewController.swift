
import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var impactTableView: UITableView!
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    
    let sampleData:[Dictionary<String, Any>] = [
        [
            "impactInfo" : "You helped treating:",
            "impact" : "10",
            "afterImpactInfo" : "children with antimalarial medicine"
        ],
        [
            "impactInfo" : "Your money funded:",
            "impact" : "7",
            "afterImpactInfo" : "malaria nets in developing countries."
        ],
        [
            "impactInfo" : "You helped treating:",
            "impact" : "70",
            "afterImpactInfo" : "with NTDs(neglected tropical diseases)"
        ]
    ]
    
    let sampleAchievements = [AchievementModel(image: UIImage(imageLiteralResourceName: "medal-2.png"), title: "Humanitarian"), AchievementModel(image: UIImage(imageLiteralResourceName: "heart_achievement.png"), title: "Sharing is caring"), AchievementModel(image: UIImage(imageLiteralResourceName: "like.png"), title: "You're awesome!")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTableView()
    }
    
    fileprivate func setupCollectionView() {
        achievementCollectionView.dataSource = self
        achievementCollectionView.delegate = self
        achievementCollectionView.register(UINib.init(nibName: "AchievementCell", bundle: nil), forCellWithReuseIdentifier: "achievementCell")
    }
    
    fileprivate func setupTableView() {
        impactTableView.dataSource = self
        impactTableView.delegate = self
        impactTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleAchievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = achievementCollectionView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        
        cell.achievementImage.image = sampleAchievements[indexPath.row].image
        cell.achievementTitle.text = sampleAchievements[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ImpactTableViewCell", owner: self, options: nil)?.first as! ImpactTableViewCell
        let impact = sampleData[indexPath.row]
        cell.impactNameLabel.text = impact["impactInfo"] as? String
        cell.impactLabel.text = impact["impact"] as? String
        cell.afterImpactLabel.text = impact["afterImpactInfo"] as? String
        return cell
    }
    

}
