
enum CharityImpactType: String{
    case childTreated = "treatchild"
    case netFounded = "malarianets"
    case ntdTreated = "treatntd"
    case none = "none"
    static let allValues = [childTreated, netFounded, ntdTreated, none]
    
    
    func getimpactDescriptionStringBeforeValue()->String{
        var string = ""
        switch(self){
        case .childTreated:
            string = "I helped treating"
        case .netFounded:
            string = "I helped funding"
        case .ntdTreated:
            string =  "I helped funding"
        default:
            string = ""
        }
        return string
    }
    
    func getimpactDescriptionStringAfterValue()->String{
        var string = ""
        switch(self){
        case .childTreated:
            string = "children with antimalarial medicine."
        case .netFounded:
            string = "malaria nets in developing countries."
        case .ntdTreated:
            string =  "people with NTDs(neglected tropical diseases)."
        default:
            string = ""
        }
        return string
    }
}
