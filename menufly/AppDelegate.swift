//
//  AppDelegate.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/3/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate  {

    var window: UIWindow?
    
    var ref:DatabaseReference?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        return true
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
//
//    func application(application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        // Initialize sign-in
//        GIDSignIn.sharedInstance().clientID = "520398104039-ieie1qcjjtesccodr843gh33c508hohp.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().delegate = self as! GIDSignInDelegate
//
//        return true
//    }
//
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential, completion: {(user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            guard let uid = user?.user.uid else {
                return
            }
            
            let values = ["name" : "", "email" : user?.user.email ]
            self.ref = Database.database().reference()
            self.ref?.child("users").child(uid).updateChildValues(values, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                print("saved user \(String(describing: user?.user.email)) into database")
                self.window?.rootViewController!.performSegue(withIdentifier: "goToHome", sender: nil)
            })
            print("logged in with google")
        })
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        try! Auth.auth().signOut()
    }
    
    


}

