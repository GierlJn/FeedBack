
#warning("TODO: Refactor Providers")
//import UIKit
//import Foundation
//
//class ImpactTableViewProvider: NSObject, UITableViewDataSource, UITableViewDelegate{
//
//    private var mappedDonations = [Donation]()
//
//    internal func updateDonations(mappedDonations: [Donation]) {
//        self.mappedDonations = mappedDonations
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return mappedDonations.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("ImpactTableViewCell", owner: self, options: nil)?.first as! ImpactTableViewCell
//        let donation = mappedDonations[indexPath.row]
//        cell.impactLabel.text = String(Int(Float(donation.impactAmount)!))
//        cell.afterImpactLabel.text = donation.impactType.getimpactDescriptionStringAfterValue()
//        return cell
//    }
//
//
//}
