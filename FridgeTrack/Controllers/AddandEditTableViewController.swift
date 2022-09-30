//
//  AddandEditTableViewController.swift
//  FridgeTrack
//
//  Created by Michael Sebsbe on 1/7/22.
//

import UIKit

class AddandEditTableViewController: UITableViewController, UINavigationControllerDelegate{
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var itemPhotoImageView: UIImageView!
    
    
    var isEditingDate = true
    var itemInFridge: FridgeItem?
    var imagePickerUIAC: UIAlertController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDatePicker()
        updateInputFields()
        updateSaveButtonState()
        
        setupUI()
        imagePickerUIAC = prepareImagePickerAlertController()
        
    }
    // UI customization methods
    
    private func setupUI(){
        saveBarButton.tintColor = UIColor(named: "Buttons")
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "Buttons")
        //navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Buttons")
        view.backgroundColor = UIColor(named: "Background")
        addPhotoButton.tintColor = UIColor(named: "Buttons")
        
        for textField in [nameTextField, caloriesTextField]{
            textField?.backgroundColor = UIColor(named: "Background")
            
        }
        
    }
    
    fileprivate func updateSaveButtonState(){
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false && itemPhotoImageView.image != nil
        saveBarButton.isEnabled = shouldEnableSaveButton
    }
    
    fileprivate func updateInputFields() {
        guard let itemInFridge = itemInFridge else{return}
        
        navigationItem.title = "Edit Item"
        nameTextField.text = itemInFridge.name
        caloriesTextField.text = "\(itemInFridge.caloriesPerPiece)"
        quantityLabel.text = "\(itemInFridge.quantity)"
        quantityStepper.value = Double(itemInFridge.quantity)
        expirationDateLabel.text = "\(itemInFridge.expirationDate.formatted(date: .abbreviated, time: .omitted))"
        expirationDatePicker.date = itemInFridge.expirationDate
        itemPhotoImageView.image = itemInFridge.image
        addPhotoButton.setTitle("Change Photo", for: .normal)
    }
    
    fileprivate func updateDatePicker() {
        if itemInFridge == nil{
            expirationDatePicker.date = Date().addingTimeInterval(365*24*60*60)}
        expirationDatePicker.minimumDate = Date()
    }
    
    // tableView DataSource methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isEditingDate && indexPath == IndexPath(row: 1, section: 2){
            return 0
        }else{
            return UITableView.automaticDimension
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == IndexPath(row: 0, section: 2){
            isEditingDate.toggle()
        }
        tableView.reloadData()
        print(isEditingDate)
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {

        imagePickerUIAC.popoverPresentationController?.sourceView = sender //for IPad
        
        present(imagePickerUIAC, animated: true, completion: nil)
    }
    
    func prepareImagePickerAlertController() -> UIAlertController{
        let alertController = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {_ in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = UIColor(named: "Buttons")
        
        return alertController
    }
    
    @IBAction func nameTextFieldEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func nameTextField(_ sender: Any) {
        caloriesTextField.becomeFirstResponder()
    }
    
    @IBAction func expirationDatePickerValueChanged(_ sender: UIDatePicker) {
        let expirationDate = sender.date
        expirationDateLabel.text = expirationDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    @IBAction func quantityStepperValueChanged(_ sender: UIStepper) {
        let quantity = Int(sender.value)
        quantityLabel.text = "\(quantity)"
    }
    
    //Navgiation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        if  itemInFridge != nil  {
            itemInFridge?.name = nameTextField.text!
            itemInFridge?.caloriesPerPiece = Int(caloriesTextField.text ?? "0")!
            itemInFridge?.quantity = Int(quantityLabel.text ?? "0")!
            itemInFridge?.expirationDate = expirationDatePicker.date
            itemInFridge?.image = itemPhotoImageView.image!
            
            
        } else{
            
            let name = nameTextField.text!
            let caloriesPerServing = Int(caloriesTextField.text ?? "0")!
            let quantity = Int(quantityLabel.text ?? "0")!
            let expirationDate = expirationDatePicker.date
            let photo = itemPhotoImageView.image!
            
            itemInFridge = FridgeItem(name: name, quantity: quantity, caloriesPerPiece: caloriesPerServing, expirationDate: expirationDate, image: photo)
        }
        
        print(itemInFridge?.expirationDate.timeIntervalSinceNow)
    }
}


extension AddandEditTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else{return}
        itemPhotoImageView.image = selectedImage
        updateSaveButtonState()
        addPhotoButton.setTitle("Change Photo", for: .normal)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
