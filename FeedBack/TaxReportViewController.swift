import UIKit
import PDFKit
import Firebase


class TaxReportViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    
    var ref: DatabaseReference!
    var allDonations = [Donation]()
    var currentUser = Auth.auth().currentUser
    var filePath: String?
    var pdfDocument: PDFDocument?
    var yOffset = 600
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pdfManager = PDFManager()
        pdfManager.createPdf()
        pdfView.autoScales = true
        pdfView.document = pdfManager.pdfDocument
        ref = Database.database().reference(withPath: "users").child(currentUser!.uid)
        ref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else { return }
            self.allDonations = user.donationHolder.donations
            for donation in self.allDonations{
                pdfManager.printDonation(donation: donation)
                pdfManager.yOffset -= 70
            }
        }
    }
    
    
    @IBAction func exportPdfButtonPressed(_ sender: Any) {
        exportRecord()
    }
    
    
    private func exportRecord(){
        let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        let fileurl =  dir?.appendingPathComponent("tax.pdf")
        let activityController = UIActivityViewController(activityItems: ["tax.pdf", fileurl!], applicationActivities: nil)
        if let popoverController = activityController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}
