

import UIKit
import Firebase
import Stripe
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            print("An error occured during Google Authentication")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if (error) != nil {
                print("Google Authentification Fail")
            } else {
                print("Google Authentification Success")
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "mainTabBarController") as! MainTabBarViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = protectedPage
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    

    var window: UIWindow?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GIDSignIn.sharedInstance().clientID = "244071801131-9g9239pdpvijhrjrq4kom0ikf9vv5h8l.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        FBSDKCoreKit.ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        STPPaymentConfiguration.shared().publishableKey = "pk_test_y9vO4PDpSho0Zp7m0ziEhJRe00pxvUYsyV"
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        downloadCharityLogos()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKCoreKit.ApplicationDelegate.shared.application(application,
                                                                   open: url,
                                                                   sourceApplication: sourceApplication,
                                                                   annotation: annotation)
        
        let isFBOpenUrl = FBSDKCoreKit.ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        let isGoogleOpenUrl = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        if isFBOpenUrl { return true }
        if isGoogleOpenUrl { return true }
        return false
        return false
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
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return FBSDKCoreKit.ApplicationDelegate.shared.application(application, open: url, options: options)
    }
    
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
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

