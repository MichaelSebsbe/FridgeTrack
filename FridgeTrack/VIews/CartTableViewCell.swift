//
//  CartTableViewCell.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 9/29/22.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var isBoughtUISwitch: UISwitch!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with cartItem: CartItem) {
        isBoughtUISwitch.isOn = cartItem.isBought
        label.text = cartItem.name
        
        isBoughtUISwitch.onTintColor = AppColors.button
        backgroundColor = AppColors.foreground
        label.font = AppFonts.subHeading
        label.textColor = AppColors.SecondaryFont
    }
    

}
