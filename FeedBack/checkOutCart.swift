
import Foundation

final class CheckoutCart {
    
    static let shared = CheckoutCart()
    
    private init() {
        // private
    }
    
    private var donations: [Donation] = []
    
    var cart: [Donation] {
        return donations
    }
    
    var canPay: Bool {
        return !donations.isEmpty
    }
    
    var total: Float {
        return donations.reduce(0) { (result, donation) -> Float in
            return result + donation.amount
        }
    }
    
    func addDonation(_ donation: Donation) {
        guard !donations.contains(donation) else {
            return
        }
        donations.append(donation)
    }
    
    func removeDonation(_ donation: Donation) -> Bool {
        guard let index = donations.firstIndex(of: donation) else {
            return false
        }
        donations.remove(at: index)
        return true
    }
    
}
