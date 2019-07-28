
import Foundation

class LevelManager{
    #warning("TODO: Create Level-System")
    static func getLevelForImpactPoints(for impactPoints: Int)-> Int{
        
        // TODO: math
        switch impactPoints{
        case 0..<10:
            return 1
        case 10..<30:
            return 2
        case 30..<70:
            return 3
        case 70..<150:
            return 4
        case 150..<310:
            return 5
        case 310...:
            return 6
        default:
            return 0
        }
    }
    
    static func getProgressUntilNextLevel(for points: Float)-> Float{
        switch points{
        case 1..<10:
            return points / 10
        case 10..<30:
            return (points - 10) / 20
        case 30..<70:
            return (points - 30) / 40
        case 70..<150:
            return (points - 70) / 80
        case 150..<310:
            return (points - 150) / 160
        case 310...:
            return (points - 310) / 9999999
        default:
            return 0
        }
    }
    
    static func getRankForLevel(level: Int)->String{
        switch level{
        case 1..<3:
            return "Newbie"
        case 3..<6:
            return "Helper"
        case 6..<12:
            return "Philantropist"
        case 12..<24:
            return "Altruist"
        case 24...:
            return "God"
        default:
            return ""
        }
    }
    
}
