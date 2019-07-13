import UIKit
import Foundation

class DonationsHistoryTableViewProvider: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    private var donations = [Donation]()
    
    internal func update(donations: [Donation]) {
        self.donations = donations
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DonationTableTableViewCell", owner: self, options: nil)?.first as! DonationTableTableViewCell
        let donation = donations[indexPath.row]
        cell.amountLabel.text = String(donation.amount) + currency
        cell.recipientLabel.text = donation.name
        cell.dateLabel.text = donation.getTimeStampAsString()
        return cell
    }
    
    
}
