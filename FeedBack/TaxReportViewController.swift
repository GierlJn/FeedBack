
import UIKit
import PDFKit
class TaxReportViewController: UIViewController {

    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = (documentsDirectory as NSString).appendingPathComponent("foo3.pdf") as String
        
        let pdfManager = PDFManager()
        pdfManager.createPdf(atFilePath: filePath)
        
        //let pdfSubView = PDFView(frame: pdfView.bounds)
        pdfView.autoScales = true
        //pdfView.addSubview(pdfSubView)
        
        // Create a PDFDocument object and set it as PDFView's document to load the document in that view.
        let pdfDocument = PDFDocument(url: URL(fileURLWithPath: filePath))!
        
        
        let squareAnnotation = PDFAnnotation(bounds: CGRect(x: 200, y: 100, width: 100, height: 100), forType: .freeText, withProperties: nil)
        squareAnnotation.color = UIColor.blue
        squareAnnotation.contents = "blablabal"
        squareAnnotation.font = UIFont.systemFont(ofSize: 20)
        squareAnnotation.backgroundColor = UIColor.lightGray
        let page = pdfDocument.page(at: 0)!
        page.addAnnotation(squareAnnotation)
        
        // Writing the changes to the file.
        pdfDocument.write(toFile: filePath)
        pdfView.document = pdfDocument
    }
    
    
    @IBAction func exportPdfButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}
