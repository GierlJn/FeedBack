
import PDFKit
import Foundation

class PDFManager{
    
    func createPdf(atFilePath filePath: String){
        
        
        let pdfTitle = "Swift-Generated PDF"
        let pdfMetadata = [
            // The name of the application creating the PDF.
            kCGPDFContextCreator: "Your iOS App",
            
            // The name of the PDF's author.
            kCGPDFContextAuthor: "Foo Bar",
            
            // The title of the PDF.
            kCGPDFContextTitle: "Lorem Ipsum",
            
            // Encrypts the document with the value as the owner password. Used to enable/disable different permissions.
            kCGPDFContextOwnerPassword: "myPassword123"
        ]
        
        // Creates a new PDF file at the specified path.
        UIGraphicsBeginPDFContextToFile(filePath, CGRect.zero, pdfMetadata)
        
        // Creates a new page in the current PDF context.
        UIGraphicsBeginPDFPage()
        
        // Default size of the page is 612x72.
        let pageSize = UIGraphicsGetPDFContextBounds().size
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        // Let's draw the title of the PDF on top of the page.
        let attributedPDFTitle = NSAttributedString(string: pdfTitle, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedPDFTitle.size()
        let stringRect = CGRect(x: (pageSize.width / 2 - stringSize.width / 2), y: 20, width: stringSize.width, height: stringSize.height)
        attributedPDFTitle.draw(in: stringRect)
        
        // Closes the current PDF context and ends writing to the file.
        UIGraphicsEndPDFContext()
    }
    
}
