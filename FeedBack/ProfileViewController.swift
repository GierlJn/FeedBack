
import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, ProfileViewDelegate {

    @IBOutlet weak var donationHistoryView: UIView!
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var achievementView: UIView!
    @IBOutlet weak var impactView: UIView!
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var impactTableView: UITableView!
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user{
                self.userNameLabel.text = user.displayName!
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    let sampleData:[Dictionary<String, Any>] = [
        [
            "impactInfo" : "You helped treating",
            "impact" : "10",
            "afterImpactInfo" : "children with antimalarial medicine."
        ],
        [
            "impactInfo" : "You helped funding",
            "impact" : "7",
            "afterImpactInfo" : "malaria nets in developing countries."
        ],
        [
            "impactInfo" : "You helped treating",
            "impact" : "70",
            "afterImpactInfo" : "people with NTDs(neglected tropical diseases)."
        ]
    ]
    
    let sampleAchievements = [AchievementModel(image: UIImage(imageLiteralResourceName: "medal-2.png"), title: "Humanitarian"), AchievementModel(image: UIImage(imageLiteralResourceName: "heart_achievement.png"), title: "Sharing is caring"), AchievementModel(image: UIImage(imageLiteralResourceName: "like.png"), title: "You're awesome!")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTableView()
        setupSeperatorLines()
    }
    
    func updateDisplayName(_ newUserName: String) {
        print("new name set")
        self.userNameLabel.text = newUserName
    }
    
    fileprivate func setupSeperatorLines(){
        setupBottomBorder(for: userProfileView)
        setupBottomBorder(for: impactView)
        setupBottomBorder(for: achievementView)
        setupBottomBorder(for: friendView)
    }
    
    fileprivate func setupBottomBorder(for view: UIView) {
        let bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: view.frame.size.height+1, width: view.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.purple.cgColor
        view.layer.addSublayer(bottomBorder)
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
    
    @IBAction func settingsButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "showSettingsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showSettingsSegue"){
            print("preparesegue")
            let settingsViewController = segue.destination as? SettingsViewController
            settingsViewController?.delegate = self
        }
    }
    

}
