
import PDFKit
import Foundation

class PDFManager{
    
    var pdfDocument: PDFDocument?
    var yOffset = 600
    var filePath: String?
    
    
    func createPdf(with fileName: String){
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        filePath = (documentsDirectory as NSString).appendingPathComponent(fileName) as String
        
        let pdfTitle = "Your tax report for 2019"
        let pdfMetadata = [
            kCGPDFContextCreator: "FeedBack",
            kCGPDFContextAuthor: "FeedBack",
            kCGPDFContextTitle: "Tax Report",
            kCGPDFContextOwnerPassword: "FeedBack"
        ]
        UIGraphicsBeginPDFContextToFile(filePath!, CGRect.zero, pdfMetadata)
        UIGraphicsBeginPDFPage()
        let pageSize = UIGraphicsGetPDFContextBounds().size
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        let attributedPDFTitle = NSAttributedString(string: pdfTitle, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedPDFTitle.size()
        let stringRect = CGRect(x: (pageSize.width / 2 - stringSize.width / 2), y: 20, width: stringSize.width, height: stringSize.height)
        attributedPDFTitle.draw(in: stringRect)
        UIGraphicsEndPDFContext()
        pdfDocument = PDFDocument(url: URL(fileURLWithPath: filePath!))!
    }
    
    func printDonation(donation: Donation){
        
        let squareAnnotation = PDFAnnotation(bounds: CGRect(x: 50, y: yOffset, width: 400, height: 60), forType: .freeText, withProperties: nil)
        squareAnnotation.color = UIColor.white
        squareAnnotation.contents = "\(donation.getTimeStampAsString()) - \(Int(Float(donation.amount)))\(currency) - \(donation.name)"
        squareAnnotation.font = UIFont.systemFont(ofSize: 20)
        let page = pdfDocument?.page(at: 0)!
        page?.addAnnotation(squareAnnotation)
        pdfDocument?.write(toFile: filePath!)
    }
    
}
