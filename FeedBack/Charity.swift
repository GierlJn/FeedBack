

import Foundation
import UIKit

class Charity{
    
    
    static let sampleData:[Dictionary<String, Any>] = [
        [
            "picture": #imageLiteral(resourceName: "malaria_consortium_logo"),
            "name" : "Malaria Consortium",
            "progress" : Float(0.33),
            "points" : "5",
            "information" : "Malaria Consortium specialises in the prevention, treatment, and control of malaria and other communicable diseases in Africa and Asia",
            "statsInfo" : "5€ may fund 1 Child treated",
            "statsSum" : "Children treated:",
            "statsSumMock" : "10"
        ],
        [
            "picture": #imageLiteral(resourceName: "sightsavers_logo"),
            "name" : "Sightsavers",
            "progress" : Float(0.7),
            "points" :  "7",
            "information" : "Sightsavers is a UK-based international charity which fights avoidable blindness and promotes equal opportunities for visually impaired people.",
            "statsInfo" : "1€ may fund 1 NTD treated",
            "statsSum" : "NTD's treated:",
            "statsSumMock" : "70"
        ],
        [
            "picture": #imageLiteral(resourceName: "logo_foundation_big_Square"),
            "name" : "Against Malaria Foundation",
            "progress" : Float(0.2),
            "points" :  "3",
            "statsInfo" : "4€ may fund 1 malaria net",
            "information" : "Against Malaria Foundation (AMF) enables distributions of long-lasting insecticide-treated bed nets (for protection against malaria) in developing countries.",
            "statsSum" : "Malaria nets funded:",
            "statsSumMock" : "7"
        ]
    ]
    

}
