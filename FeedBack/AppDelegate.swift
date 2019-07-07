

import UIKit
import Firebase
import Stripe
import FBSDKCoreKit
import GoogleSignIn
import UserNotifications

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
                
                let userManager = UserManager()
                userManager.isUserRegistered(with: Auth.auth().currentUser!.uid, completion: { (userExists, user) in
                    
                    if(!userExists){
                        print("user does not exist")
                        userManager.createInitialUserInfo(withUsername: "Google name")
                    }else{
                        print("user exists")
                    }
                    
                    
                    let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                    let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "mainTabBarController") as! MainTabBarViewController
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = protectedPage
                })
                
                
                
                
            }
        }
    }
    
    func setGoogleDelegate(){
        GIDSignIn.sharedInstance().delegate = self
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        
        // Print message ID.
        //    if let messageID = userInfo[gcmMessageIDKey]
        //    {
        //      print("Message ID: \(messageID)")
        //    }
        
        // Print full message.
        print(userInfo)
        
        //    let code = String.getString(message: userInfo["code"])
        guard let aps = userInfo["aps"] as? Dictionary<String, Any> else { return }
        guard let alert = aps["alert"] as? String else { return }
        //    guard let body = alert["body"] as? String else { return }
        
        completionHandler([])
    }
    
    // Handle notification messages after display notification is tapped by the user.
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        completionHandler()
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    


}

