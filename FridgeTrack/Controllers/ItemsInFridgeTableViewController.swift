//
//  ItemsInFridgeTableViewController.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 1/7/22.
//

import UIKit

class ItemsInFridgeTableViewController: UITableViewController {
    
    var itemsInFridge = [Item]() {
        didSet{
            saveChanges()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadSavedItems()
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsInFridge.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        
        let item = itemsInFridge[indexPath.row]
        
        // Configure the cell...
        cell.update(with: item)
        
        //if expired
        if item.expirationDate.timeIntervalSinceNow < 0 {
                cell.warningImageView.isHidden = false
                cell.warningImageView.tintColor = .systemRed
        }
        
        // if exp in 3 days
        else if item.expirationDate.timeIntervalSinceNow < (86_000 * 3){
            cell.warningImageView.isHidden = false
            cell.warningImageView.tintColor = .systemOrange
        } else {
            cell.warningImageView.isHidden = true
        }
        
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            itemsInFridge.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func unwindToItemsInFridge(segue: UIStoryboardSegue){
        guard segue.identifier == "saveUnwind",
              let addAndEditViewcontroller = segue.source as? AddandEditTableViewController,
              let item = addAndEditViewcontroller.itemInFridge else {return}
        
        if let editingCellIndexPath = tableView.indexPathForSelectedRow{
            itemsInFridge[editingCellIndexPath.row] = item
        } else {
            itemsInFridge.append(item)
            
        }
        sortItemsInFridgeByExpirationDate()
        tableView.reloadData()
        
    }
    
    @IBSegueAction func editItem(_ coder: NSCoder, sender: Any?) -> AddandEditTableViewController? {
        
        let addAndEditTableViewController = AddandEditTableViewController(coder: coder)

        guard let cell = sender as? ItemTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {return addAndEditTableViewController}
        
        addAndEditTableViewController?.itemInFridge = itemsInFridge[indexPath.row]
        
        return addAndEditTableViewController
    }
    
    func saveChanges(){
        var codableItem = [CodableItem]()
        
        for item in itemsInFridge{
            codableItem.append(CodableItem(item: item))
        }
        
        CodableItem.saveItems(codableItems: codableItem)
        
    }
    
    fileprivate func loadSavedItems() {
        if let decodedItems = CodableItem.loadSavedItems(){
            let items = CodableItem.convertToItems(codableItems: decodedItems)
            itemsInFridge = items
        }else{
            itemsInFridge = Item.loadSampleItems()
        }
        sortItemsInFridgeByExpirationDate()
    }
    
    fileprivate func setupUI() {
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.backgroundColor = AppColors.bgColor
        navigationItem.leftBarButtonItem?.tintColor = AppColors.buttonColors
    }
    
    fileprivate func sortItemsInFridgeByExpirationDate(){
        itemsInFridge = itemsInFridge.sorted(by: {$0.expirationDate < $1.expirationDate})
    }
    
}
