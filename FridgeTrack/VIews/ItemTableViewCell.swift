//
//  ItemTableViewCell.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 1/7/22.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var warningImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with item: Item){
        nameLabel.text = item.name
        quantityLabel.text = "\(item.quantity) left"
        caloriesLabel.text = "\(item.caloriesPerPiece) calories"
        expirationDateLabel.text = "Exp: \(item.expirationDate.formatted(date: .abbreviated, time: .omitted))"
        photoImageView.image = item.image
        photoImageView.layer.cornerRadius = 10
    }

}
