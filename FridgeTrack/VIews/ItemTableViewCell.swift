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
    
    @IBOutlet weak var warningButton: UIButton!
    @IBOutlet weak var expiryLabel: UILabel!
    
    var item: FridgeItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI(){
  
        self.backgroundColor = UIColor(named: "Foreground")
        nameLabel.textColor = UIColor(named: "PrimaryFont")
        for label in [quantityLabel, caloriesLabel, expirationDateLabel]{
            label?.textColor = UIColor(named: "SencondaryColor")
        }
        warningButton.titleLabel?.isHidden = true
        expiryLabel.isHidden = true
        expiryLabel.textColor = .white
    }
    
    func update(with item: FridgeItem){
        self.item = item
        nameLabel.text = item.name
        quantityLabel.text = "\(item.quantity) left"
        caloriesLabel.text = "\(item.caloriesPerPiece) calories"
        expirationDateLabel.text = "Exp: \(item.expirationDate.formatted(date: .abbreviated, time: .omitted))"
        photoImageView.image = item.image
        photoImageView.layer.cornerRadius = 10
        expiryLabel.text =  item.isExpired ? "Expired" : "Expires in \(item.daysUntilExpiry) days"
        
        if item.isExpired {
                warningButton.isHidden = false
                warningButton.tintColor = .systemRed
        }
        
        // if exp in 3 days
        else if item.expirationDate.timeIntervalSinceNow < (86_000 * 3){
            warningButton.isHidden = false
            warningButton.tintColor = .systemYellow
        } else {
            warningButton.isHidden = true
        }
        
        
        expiryLabel.backgroundColor = warningButton.tintColor
        
    }

    
    @IBAction func warningButtonTapped(_ sender: UIButton) {
        expiryLabel.isHidden.toggle()
    }
    
}
