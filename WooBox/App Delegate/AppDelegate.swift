//
//  AppDelegate.swift

import UIKit
import IQKeyboardManagerSwift
import REFrostedViewController
import Fabric
import Crashlytics
import Firebase
import GoogleMobileAds
import GoogleSignIn
import FirebaseAuth
import OneSignal

var PRIMARY_COLOR = String()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, REFrostedViewControllerDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var frostedViewController: REFrostedViewController?
    var navigationController = TNavigationViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        TPreferences.writeBoolean(PUSH_NOTIFICATION, value: false)

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        PRIMARY_COLOR = TPreferences.readString(THEME_COLOR) ?? "fc4253"
        if PRIMARY_COLOR == "" {
            PRIMARY_COLOR = "fc4253"
        }
        THelper.SetLanguage_RTL()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)

        if TPreferences.readBoolean(WALKTHROUGH) {
            let vc = SplashViewController(nibName: "SplashViewController", bundle: nil)
            navigationController = TNavigationViewController(rootViewController: vc)
        }
        else {
            let vc = WalkThroughViewController(nibName: "WalkThroughViewController", bundle: nil)
            navigationController = TNavigationViewController(rootViewController: vc)
        }
        navigationController.isNavigationBarHidden = true
        self.window? .makeKeyAndVisible()
        let menuController = SideBarMenuViewController(nibName: "SideBarMenuViewController", bundle: nil)
        
        frostedViewController = REFrostedViewController(contentViewController: navigationController, menuViewController: menuController)
        sideDrawerDirection()
        frostedViewController?.liveBlurBackgroundStyle = .light
        frostedViewController?.liveBlur = true
        frostedViewController?.delegate = self
        frostedViewController?.panGestureEnabled = false
        window?.rootViewController = frostedViewController
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            print("Received Notification: \(notification!.payload.notificationID ?? "")")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            TPreferences.writeBoolean(PUSH_NOTIFICATION, value: true)
            let payload: OSNotificationPayload = result!.notification.payload
            
            var fullMessage = payload.body
            print("Message = \(String(describing: fullMessage))")
            
            if payload.additionalData != nil {
                if payload.title != nil {
                    let messageTitle = payload.title
                    print("payload.category \(payload.category ?? "")")
                    print("payload.subtitle \(payload.subtitle ?? "")")
                    print("Message Title = \(messageTitle!)")
                }
                
                let additionalData = payload.additionalData
                if additionalData?["actionSelected"] != nil {
                    fullMessage = fullMessage! + "\nPressed ButtonID: \(String(describing: additionalData!["actionSelected"]))"
                }
            }
        }
                        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: ONESIGNAL_APP_ID,
                                        handleNotificationReceived: notificationReceivedBlock,
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })

        application.registerForRemoteNotifications()
        registerForRemoteNotification()
        
        return true
    }
    
    // MARK: -
    // MARK: - Push Notification
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { granted, error in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            })
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let strDevicetoken = "\(deviceToken.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: ""))"
        print("Device Token = \(strDevicetoken)")
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        
        UserDefaults.standard.set(token, forKey: "devicetoken_data")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.noData);
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    // MARK: -
    // MARK: - UNUserNotificationCenter Delegate >= iOS 10 UNUserNotificationCenter
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let dic: NSDictionary = response.notification.request.content.userInfo as NSDictionary
        print("\(dic)")
//        let dicCustom: NSDictionary = dic.value(forKey: "custom") as! NSDictionary
//        if dicCustom.value(forKey: "a") != nil {
//            let dicA: NSDictionary = dicCustom.value(forKey: "a") as! NSDictionary
//        }
    }
    
    class func getDelegate() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func sideDrawerDirection() {
        if THelper.isRTL() {
            frostedViewController?.direction = .right
        }
        else {
            frostedViewController?.direction = .left
        }
    }
    
//    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log  into Google: ", err)
            return
        }
        print("SuccessFully logged in to Google: ", user ?? "")
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
                
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
            if let err = error {
                print("Failed to Created a firebase user with Google Account: ", err)
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

