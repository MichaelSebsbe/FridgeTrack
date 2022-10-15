//
//  CartViewController.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 9/29/22.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usersStackView: UIStackView!
    
    var cartItems = [CartItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        
    }
    
    private func setupUI(){
        view.backgroundColor = AppColors.bgColor
        tableView.backgroundColor = AppColors.bgColor
        tableView.layer.cornerRadius = 10
        tableView.rowHeight = 50
        
        if let user = UserManager.shared.user{
            let userView = UserView(user: user)
            //usersStackView.addSubview(userView.draw())
            let loggedInUserStackView = UserView(user: user).draw()
            var tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnUser(_:)))
            loggedInUserStackView.addGestureRecognizer(tap)
            
            usersStackView.addArrangedSubview(loggedInUserStackView)
    
            
            let addPersonStackView = UserView().draw()
            tap =  UITapGestureRecognizer(target: self, action: #selector(self.tappedOnAddUser(_:)))
            addPersonStackView.addGestureRecognizer(tap)
            
            
            usersStackView.addArrangedSubview(addPersonStackView)
        }
    }
    
    @objc func tappedOnUser(_ sender: UITapGestureRecognizer? = nil){
        print("UserView Tapped")
        // go to settings for user
        //friend request
     
    }
    
    @objc func tappedOnAddUser(_ sender: UITapGestureRecognizer? = nil){
        print("Add User Tapped")
        // go to search for users
     
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add Item", message: "Add item to your shopping cart.", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Carrot🥕"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let field = alertController.textFields?.first,
               let text = field.text {
                
                let cartItem = CartItem(name: text)
                self.cartItems.append(cartItem)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
        
    }
    
    // MARK: TableView DataSource Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return cartItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < cartItems.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath)
            cell.layer.cornerRadius = 20
            
            return cell
        }
        
        let cartItem = cartItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! CartTableViewCell
        cell.configure(with: cartItem)
        
        return cell
    }
    
}
