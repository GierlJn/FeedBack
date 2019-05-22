

import Foundation
import Firebase

enum CharityCategory: String{
    case animals = "animals"
    case health = "health"
    case enviromental = "enviromental"
    case others = "others"
    static let allValues = [animals, health, enviromental, others]
}


class Charity: NSObject{
    var cid: String
    var name: String
    var category: CharityCategory
    var impactPerDollar: Float
    var impactType: CharityImpactType
    var website: String
    var logo: String
    var longInformation: String
    var sourceLink: String
    var about: String

    
    init(cid: String, name: String, impactCount: Float, impactType: CharityImpactType, website: String, category: CharityCategory, logo: String, longInformation: String, sourceLink: String, about: String){
        self.cid = cid
        self.name = name
        self.impactPerDollar = impactCount
        self.impactType = impactType
        self.website = website
        self.category = category
        self.logo = logo
        self.longInformation = longInformation
        self.sourceLink = sourceLink
        self.about = about
    }
    
    init?(snapshot: DataSnapshot){
        let cid = snapshot.key
        guard let charityDb = snapshot.value as? [String:Any] else { return nil }
        guard let name = charityDb[namePath] as? String else { return nil }
        guard let categoryAsString = charityDb[categoryPath] as? String else { return nil }
        guard let impactPerDollar = charityDb[impactPerDollarPath] as? String else { return nil }
        guard let impactTypeAsString = charityDb[impactTypePath] as? String else { return nil }
        guard let website = charityDb[websitePath] as? String else { return nil }
        guard let logo = charityDb[logoPath] as? String else { return nil }
        guard let longInformation = charityDb[longInformationPath] as? String else { return nil }
        guard let sourceLink = charityDb[sourceLinkPath] as? String else { return nil }
        guard let about = charityDb[aboutPath] as? String else { return nil }
        
        self.cid = cid
        self.name = name
        self.category = CharityCategory.init(rawValue: categoryAsString) ?? CharityCategory.others
        self.impactPerDollar = Float(impactPerDollar)!
        self.impactType = CharityImpactType.init(rawValue: impactTypeAsString) ?? CharityImpactType.none
        self.website = website
        self.logo = logo
        self.longInformation = longInformation
        self.sourceLink = sourceLink
        self.about = about
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

