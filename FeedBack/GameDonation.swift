import Foundation
import Firebase

class GameDonation: NSObject{
    var name: String
    var impactType: CharityImpactType
    var impactAmount: String
    var logo: String
    var logoImage: UIImage?
    
    init(name: String, impactType: CharityImpactType, impactAmount: String, logo: String){
        self.name = name
        self.impactType = impactType
        self.impactAmount = impactAmount
        self.logo = logo
    }
    
    init?(snapshot: DataSnapshot){
        guard let donationDb = snapshot.value as? [String:Any] else {
            print("donation not found")
            return nil }
        guard let name = donationDb[namePath] as? String else {
            print("charityName not found")
            return nil }
        guard let impactTypeAsString = donationDb[impactTypeChildPath] as? String else {
            print("impactTypeAsString not found")
            return nil }
        guard let impactAmount = donationDb[impactAmountPath] as? String else {
            print("impactAmount not found")
            return nil }
        guard let logo = donationDb[logoPath] as? String else {
            print("logo not found")
            return nil }
        
        self.name = name
        self.impactType = CharityImpactType.init(rawValue: impactTypeAsString) ?? CharityImpactType.none
        self.impactAmount = impactAmount
        self.logo = logo
    }
    
    func getLogoImage()->UIImage?{
        if(!isLogoDownloaded()){
            print("not downloaded")
            return nil
        }
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        guard let url = NSURL(fileURLWithPath: path).appendingPathComponent(logo) else { return nil }
        guard let image = UIImage(contentsOfFile: url.path) else {
            print(url.path)
            print("image couldnt load)")
            return nil
        }
        return image
    }
    
    private func isLogoDownloaded()->Bool{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(logo) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

}


