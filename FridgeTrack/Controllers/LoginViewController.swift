//
//  LoginViewController.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 9/30/22.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI

class LoginViewController: UIViewController, FUIAuthDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // so that after login this page is fully covered
        modalPresentationStyle = .fullScreen
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //FirebaseApp.configure()
        let authUI = FUIAuth.defaultAuthUI()!
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(authUI: authUI), FUIEmailAuth()]
        
        
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
        authUI.providers = providers
        
        let authViewController = authUI.authViewController()
        
        //present(authViewController, animated: true)
        show(authViewController, sender: nil)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        return true
      }
      // other URL handling goes here.
      return false
    }
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
      // handle user and error as necessary
        if let error = error{
            print(error.localizedDescription)
        } else {
            if let user = user {
                let loggedInUser = FridgeTrackUser(name: user.displayName, id: user.uid)
                UserManager.shared.user = loggedInUser
                
                self.dismiss(animated: true)
            }
       
        }
    }
}
