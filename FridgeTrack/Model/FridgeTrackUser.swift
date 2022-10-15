//
//  UserManager.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 10/1/22.
//

import UIKit

struct FridgeTrackUser {
    let name: String?
    let id: String
    let profilePic = UIImage(systemName: "person.crop.circle")?.withTintColor(AppColors.button!)
}
