//
//  UserView.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 10/11/22.
//

import UIKit

// will add a tap geustue recognizer to take to users profile
class UserView {
    let user: FridgeTrackUser?
    //let callBack: () -> ()
    
    init(user: FridgeTrackUser? = nil) {
        self.user = user
            // self.callBack = callBack
    }
    
    func draw() -> UIStackView {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        //stackView.addGestureRecognizer(tap)
        
        
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.addGestureRecognizer(tap)
        
        let nameLabel = UILabel()
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        
        // fill stack view with user image and name
        if let user = user{
            imageView.image = user.profilePic
            //imageView.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.text = user.name
            //let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel]
        } else{ //will creata a stack for add user
            imageView.image = UIImage(systemName: "person.crop.circle.badge.plus")
            nameLabel.text = "Add Person"
            
        }
        
        return stackView
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil){
        print("UserView Tapped")
        
       // callBack()
    }
    
}
