
import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        achievementCollectionView.dataSource = self
        achievementCollectionView.delegate = self
        achievementCollectionView.register(UINib.init(nibName: "AchievementCell", bundle: nil), forCellWithReuseIdentifier: "achievementCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let user = UserDataModel.sampleData
        let achievements = user["achievements"] as! [AchievementModel]
        return achievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = achievementCollectionView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        let user = UserDataModel.sampleData
        let achievements = user["achievements"] as! [AchievementModel]
    
        
        cell.achievementImage.image = achievements[indexPath.row].image
        cell.achievementTitle.text = achievements[indexPath.row].title
        return cell
    }
    

}
