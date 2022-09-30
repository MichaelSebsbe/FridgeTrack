//
//  Item.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 1/7/22.
//

import UIKit

struct FridgeItem: Equatable{
    var name: String
    var quantity: Int
    var caloriesPerPiece: Int
    var expirationDate: Date
    var image: UIImage
    var isExpired: Bool {
        if expirationDate.timeIntervalSinceNow < 0 {
            return true
        }
        return false
    }
    var daysUntilExpiry: Int {
        return Int((expirationDate.timeIntervalSinceNow/86400).rounded(.up))
    }
    
    init(name: String, quantity: Int, caloriesPerPiece: Int, expirationDate: Date, image: UIImage){
        self.name = name
        self.quantity = quantity
        self.caloriesPerPiece = caloriesPerPiece
        self.expirationDate = expirationDate
        self.image = image
    }
    
    init(codableItem: CodableItem){
        self.name = codableItem.name
        self.quantity = codableItem.quantity
        self.caloriesPerPiece = codableItem.caloriesPerPiece
        self.expirationDate = codableItem.expirationDate
        self.image = UIImage(data: codableItem.imageData)!
    }
    
    static func == (lhs: FridgeItem, rhs: FridgeItem) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func loadSavedItems() -> [FridgeItem]?{
        return nil
    }
    static func loadSampleItems() -> [FridgeItem] {
        let item1 = FridgeItem(name: "Milk", quantity: 1, caloriesPerPiece: 1000, expirationDate: Date(), image: UIImage(named: "Milk")!)
        let item2 = FridgeItem(name: "Ground Beef", quantity: 1, caloriesPerPiece: 1000, expirationDate: Date(), image: UIImage(named: "GroundBeef")!)
        return [item1, item2]
    }
    static func applySelectionSort(to items: [FridgeItem]) -> [FridgeItem]{
        
        
        var sortedItems = [FridgeItem]()
        var tempArray = items
        
        for _ in tempArray{
            var minimumValueIndex = 0
            var minimumDate = Date()
            minimumDate = .distantFuture
            for index in 0...tempArray.count - 1{
                if tempArray[index].expirationDate < minimumDate{
                    minimumDate = tempArray[index].expirationDate
                    minimumValueIndex = index
                }
            }
            sortedItems.append(tempArray[minimumValueIndex])
            tempArray.remove(at: minimumValueIndex)
        }
        return sortedItems
    }
}
struct CodableItem: Codable{
    var name: String
    var quantity: Int
    var caloriesPerPiece: Int
    var expirationDate: Date
    var imageData: Data
    
    init(item: FridgeItem){
        self.name = item.name
        self.quantity = item.quantity
        self.caloriesPerPiece = item.caloriesPerPiece
        self.expirationDate = item.expirationDate
        self.imageData = item.image.jpegData(compressionQuality: 0.9)!
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! //accesing a folder to save
    
    static let archiveURL = documentsDirectory.appendingPathComponent("Item").appendingPathExtension("plist")
    //creating a file Item.plist
    static func loadSavedItems() -> [CodableItem]?{
        guard let codedItems = try? Data(contentsOf: archiveURL) else{return nil}
        let pListDecoder = PropertyListDecoder()
        if let decodedItem = try? pListDecoder.decode([CodableItem].self, from: codedItems){
            return decodedItem
        }else{return nil}
    }
    
    static func saveItems(codableItems: [CodableItem]){
        let pListEncoder = PropertyListEncoder()
        let codedItems = try? pListEncoder.encode(codableItems)
        try? codedItems?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func convertToItems(codableItems: [CodableItem]) -> [FridgeItem]{
        var items = [FridgeItem]()
        for codableItem in codableItems {
            items.append(FridgeItem(codableItem: codableItem))
        }
        return items
    }
    
}
