import UIKit
import Foundation

class AchievementCollectionViewProvider: NSObject, UICollectionViewDelegate, UICollectionViewDataSource{

    private let achievementManager = AchievementManager()
    private var achievements = [AchievementFirebaseEntry]()

    internal func userDataUpdated(achievements: [AchievementFirebaseEntry]) {
        self.achievements = achievements
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementManager.availableAchievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        let achievementForCell = achievementManager.availableAchievements[indexPath.row]
        
        if(!userHasAchievement(achievementId: achievementForCell.key)){
            cell.achievementImage.alpha = 0.3
            cell.achievementTitle.alpha = 0.3
        }else{
            cell.achievementImage.alpha = 1
            cell.achievementTitle.alpha = 1
        }
        
        cell.achievementImage.image = achievementForCell.image
        cell.achievementTitle.text = achievementForCell.name
        return cell
    }
    
    func userHasAchievement(achievementId: String)->Bool{
        if(self.achievements.contains(where: { (entry) -> Bool in
            entry.id == achievementId
        })){
            return true
        }else{
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let achievement = achievementManager.availableAchievements[indexPath.row]
        if(userHasAchievement(achievementId: achievement.key)){
            let achievementWithDate = achievements.first { (entry) -> Bool in
                entry.id == achievement.key
            }
            let achievementAchievedDate = achievementWithDate?.getTimeStampAsString()
            let alert = UIAlertController(title: achievement.name, message: "\(achievement.messageWhenAchieved)\n\(achievementAchievedDate ?? "")", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: achievement.name, message: "\(achievement.description)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    

}
