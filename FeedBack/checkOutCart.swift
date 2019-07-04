
import Foundation

final class CheckoutCart {
    
    static let shared = CheckoutCart()
    
    private init() {
        // private
    }
    
    private var transactions: [Transaction] = []
    
    var cart: [Transaction] {
        return transactions
    }
    
    var canPay: Bool {
        return !transactions.isEmpty
    }
    
    var total: Int {
        return transactions.reduce(0) { (result, transaction) -> Int in
            return result + transaction.amount
        }
    }
    
    func addTransaction(_ transaction: Transaction) {
//        guard !transactions.contains(transaction) else {
//            return
//        }
        transactions.append(transaction)
    }
    
    func removeTransaction(_ transaction: Transaction) -> Bool {
        return true
//        guard let index = transactions.firstIndex(of: transaction) else {
//            return false
//        }
//        transactions.remove(at: index)
//        return true
    }
    
}
