//
//  UIViewController+alerts.swift
//  FeedBack
//
//  Created by Julian on 15.05.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import Foundation
import UIKit


private let kPleaseWaitAssociatedObjectKey = "_UIViewControllerAlertCategory_PleaseWaitScreenAssociatedObject"
private let kOK = "OK"
private let kCancel = "Cancel"

typealias AlertPromptCompletionBlock = (Bool, String?) -> Void

class SimpleTextPromptDelegate: NSObject, UIAlertViewDelegate {
    private var completionHandler: AlertPromptCompletionBlock?
    private var retainedSelf: SimpleTextPromptDelegate?
    
    override init() {
    }
    required init(completionHandler: @escaping AlertPromptCompletionBlock) {
        super.init()
        self.completionHandler = completionHandler
        retainedSelf = self
    }

}

extension UIViewController{
    
    func showShareActivityOptions(_ text: String) {
        let textToShare = [ text ]
        let activityController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        if let popoverController = activityController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        activityController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        self.present(activityController, animated: true, completion: nil)
    }
    
    func showTextInputPrompt(withMessage message: String?, completionBlock completion: @escaping AlertPromptCompletionBlock) {
        let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        weak var weakPrompt: UIAlertController? = prompt
        let cancelAction = UIAlertAction(title: kCancel, style: .cancel, handler: { action in
            completion(false, nil)
        })
        let okAction = UIAlertAction(title: kOK, style: .default, handler: { action in
            let strongPrompt: UIAlertController? = weakPrompt
            completion(true, strongPrompt?.textFields![0].text)
        })
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(cancelAction)
        prompt.addAction(okAction)
        present(prompt, animated: true)
    }
    
    func showMessagePrompt(_ message: String?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: kOK, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func showMessagePromptWithTitle(_ message: String?, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: kOK, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func showSpinner(_ completion: (() -> Void)? = nil) {
        var pleaseWaitAlert: UIAlertController? = objc_getAssociatedObject(self, (kPleaseWaitAssociatedObjectKey)) as? UIAlertController
        if pleaseWaitAlert != nil {
            if completion != nil {
                completion?()
            }
            return
        }
        pleaseWaitAlert = UIAlertController(title: nil, message: "Please Wait...\n\n\n\n", preferredStyle: .alert)
        
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = UIColor.black
        spinner.center = CGPoint(x: (pleaseWaitAlert?.view.bounds.size.width ?? 0.0) / 2, y: (pleaseWaitAlert?.view.bounds.size.height ?? 0.0) / 2)
        spinner.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        spinner.startAnimating()
        pleaseWaitAlert?.view.addSubview(spinner)
        
        objc_setAssociatedObject(self, (kPleaseWaitAssociatedObjectKey), pleaseWaitAlert, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if let pleaseWaitAlert = pleaseWaitAlert {
            present(pleaseWaitAlert, animated: true, completion: completion)
        }
    }
    
    func hideSpinner(_ completion: (() -> Void)? = nil) {
        let pleaseWaitAlert: UIAlertController? = objc_getAssociatedObject(self, (kPleaseWaitAssociatedObjectKey)) as? UIAlertController
        
        pleaseWaitAlert?.dismiss(animated: true, completion: completion)
        
        objc_setAssociatedObject(self, (kPleaseWaitAssociatedObjectKey), nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
