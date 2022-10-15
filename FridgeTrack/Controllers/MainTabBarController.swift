//
//  UITabBarController.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 10/1/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //if no user is logged in, we'll present login screen
        if !UserManager.shared.isUserLoggedIn{
            performSegue(withIdentifier: "goToLogin", sender: nil)
            //present(LoginViewController(), animated: true)
        }

    }
}
