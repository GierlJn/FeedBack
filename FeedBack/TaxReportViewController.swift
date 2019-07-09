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
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        filePath = (documentsDirectory as NSString).appendingPathComponent("tax.pdf") as String
        
        let pdfManager = PDFManager()
        pdfManager.createPdf(atFilePath: filePath!)
        pdfView.autoScales = true
        
        // Create a PDFDocument object and set it as PDFView's document to load the document in that view.
        pdfDocument = PDFDocument(url: URL(fileURLWithPath: filePath!))!
        pdfView.document = pdfDocument
        
        ref = Database.database().reference(withPath: "users").child(currentUser!.uid)
        ref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else { return }
            self.allDonations = user.donationHolder.donations
            for donation in self.allDonations{
                self.printDonation(donation: donation)
                self.yOffset -= 70
            }
        }
        
        
       
    }
    
    func printDonation(donation: Donation){
        let squareAnnotation = PDFAnnotation(bounds: CGRect(x: 50, y: yOffset, width: 400, height: 60), forType: .freeText, withProperties: nil)
        squareAnnotation.color = UIColor.white
        squareAnnotation.contents = "\(donation.getTimeStampAsString()) - \(Int(Float(donation.amount)))\(currency) - \(donation.name)"
        squareAnnotation.font = UIFont.systemFont(ofSize: 20)
        let page = pdfDocument?.page(at: 0)!
        page?.addAnnotation(squareAnnotation)
        // Writing the changes to the file.
        pdfDocument?.write(toFile: filePath!)
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
