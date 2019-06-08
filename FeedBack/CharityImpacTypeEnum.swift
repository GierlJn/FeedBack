
enum CharityImpactType: String{
    case childTreated = "treatchild"
    case netFounded = "malarianets"
    case ntdTreated = "treatntd"
    case none = "none"
    static let allValues = [childTreated, netFounded, ntdTreated, none]
    
    
    func getimpactDescriptionStringBeforeValue()->String?{
        switch(self){
        case .childTreated:
            return "I helped treating"
        case .netFounded:
            return "I helped funding"
        case .ntdTreated:
            return  "I helped funding"
        default:
            return nil
        }
    }
    
    func getimpactDescriptionStringAfterValue()->String?{
        switch(self){
        case .childTreated:
            return "children with antimalarial medicine."
        case .netFounded:
            return "malaria nets in developing countries."
        case .ntdTreated:
            return "treatments for people with NTDs."
        default:
            return nil
        }
    }
    
    func getShortDescription()->String?{
        switch(self){
        case .childTreated:
            return "children treated"
        case .netFounded:
            return "funded malaria nets"
        case .ntdTreated:
            return "treated people"
        default:
            return nil
        }
    }
}
