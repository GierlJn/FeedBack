//
//  AppDelegate.swift
//  FeedBack
//
//  Created by Julian on 06.04.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit
import Firebase
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        STPPaymentConfiguration.shared().publishableKey = "pk_test_y9vO4PDpSho0Zp7m0ziEhJRe00pxvUYsyV"
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        //let database = Database.database().reference()
        //database.setValue("Test sent data")
        downloadCharityLogos()
        return true
    }
    
    func downloadCharityLogos(){
        let ref: DatabaseReference! = Database.database().reference(withPath: charityPath)
        ref.observe(DataEventType.value) { (snapshot) in
            for case let charitySnapshot as DataSnapshot in snapshot.children{
                guard let charity = Charity(snapshot: charitySnapshot) else { return }
                if(!self.isLogoInCache(charity.logo)){
                    self.downloadLogo(charity.logo)
                }else{
                    print("\(charity.logo) is already cached")
                }
            }
        }
    }
    
    func downloadLogo(_ logoFileName: String){
        let storage: Storage = Storage.storage()
        let reference: StorageReference = storage.reference(forURL: "gs://feedback-cf3dc.appspot.com/" + logoFileName)
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        guard let localURL = NSURL(fileURLWithPath: path).appendingPathComponent(logoFileName) else {
            print("error: url not found")
            return
        }
        reference.write(toFile: localURL) { url, error in
            if let error = error {
                print("An error occurred!: \(error)")
            } else {
                print("Local file for \(logoFileName) is saved")
            }
        }
    }
    
    func isLogoInCache(_ logoFileName: String)->Bool{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(logoFileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
/*
 func getLogo(){
 let cachedDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
 let localUrl = cachedDirectory.appendingPathComponent(fileName)
 if(FileManager.default.fileExists(atPath: localUrl)){
 //getLogoFromCache
 }else{
 //downloadLogo
 }
 }
 
 func getLogoFromCache(_ fileName: String){
 
 }
 
 func downloadLogo(_ fileName: String, completion: @escaping(UIImage?, Error?)->()){
 let localUrl = ""
 
 if(FileManager.default.fileExists(atPath: localUrl)){
 
 }
 
 let storage: Storage = Storage.storage()
 let reference: StorageReference = storage.reference(forURL: "gs://feedback-cf3dc.appspot.com/")
 reference.downloadURL { (url, error) in
 guard let imageUrl = url, error == nil else {
 print("Error: check Url")
 completion(nil, error)
 return
 }
 guard let data = NSData(contentsOf: imageUrl) else {
 print("Error: check Url")
 completion(nil, error)
 return
 }
 guard let image = UIImage(data: data as Data) else {
 completion(nil, error)
 return
 }
 completion(image, nil)
 
 }
 }
 */

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

