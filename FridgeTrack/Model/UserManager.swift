//
//  UserManager.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 10/1/22.
//

import Foundation


struct UserManager {
    static var shared = UserManager()
    
    var user : FridgeTrackUser? {
        didSet {
            // save on device
            let defaults = UserDefaults.standard
            
            defaults.set(user?.name, forKey: "userName")
            defaults.set(user?.id, forKey: "userID")
        }
    }
    
    var isUserLoggedIn: Bool {
        return user == nil ? false : true
    }
    
    private init() {
        let defaults = UserDefaults.standard
        if let userName = defaults.string(forKey: "userName"),
           let userID = defaults.string(forKey: "userID")
        {
            self.user = FridgeTrackUser(name: userName, id: userID)
        }
    }
}
