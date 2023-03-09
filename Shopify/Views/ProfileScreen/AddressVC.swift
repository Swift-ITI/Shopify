//
//  AddressVC.swift
//  Shopify
//
//  Created by Michael Hany on 25/02/2023.
//

import UIKit

class AddressVC: UIViewController
{

// MARK: - IBOutlets Part

    @IBOutlet var addressesTable: UITableView!
    {
        didSet
        {
            addressesTable.delegate = self
            addressesTable.dataSource = self
            addressesTable.layer.borderColor = UIColor(red: 0.686, green: 0.557, blue: 0.451, alpha: 1).cgColor
            addressesTable.layer.borderWidth = 1.5
            addressesTable.layer.cornerRadius = 20
            
            let addressesNib = UINib(nibName: "AddressesCell", bundle: nil)
            addressesTable.register(addressesNib, forCellReuseIdentifier: "addressesCell")
        }
    }
    @IBOutlet var addNewAddressButton: UIButton!
    {
        didSet
        {
            addNewAddressButton.layer.masksToBounds = true
            addNewAddressButton.layer.cornerRadius = addNewAddressButton.frame.width/18
        }
    }
    
// MARK: - AddressVC Part

    var userID : Int?
    var userDetails : Customers?
    var arrOfAddresses : AddressesResult?
    var userVM : UserViewModel?
    var deleteVM : PostAddressViewModel?
    var editVM : PostAddressViewModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userVM = UserViewModel()
        editVM = PostAddressViewModel()
        deleteVM = PostAddressViewModel()
        userVM?.fetchUsers(target: .searchCustomerByID(id: userID ?? 6810321223958))
        userVM?.fetchAddresses(target: .searchCustomerAddresses(id: userID ?? 6810321223958))
        userVM?.bindDataToVC = { () in self.renderDataView()
            self.addressesTable.reloadData()}
        userVM?.bindAddressToVC = { () in self.renderAddressView()
            self.addressesTable.reloadData()}
        addressesTable.reloadData()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.addressesTable.reloadData()
        userVM?.fetchAddresses(target: .searchCustomerAddresses(id: userID ?? 6810321223958))
        userVM?.bindAddressToVC = { () in self.renderAddressView()
            self.addressesTable.reloadData()
        }
        //addressesTable.reloadData()
        //self.renderAddressView()
    }
    
    func renderDataView()
    {
        DispatchQueue.main.async
        {
            self.userDetails = self.userVM?.users
            print(self.userDetails?.customers.first?.email ?? "none")
        }
    }
    
    func renderAddressView()
    {
        DispatchQueue.main.async
        {
            self.arrOfAddresses = self.userVM?.addresses
            self.addressesTable.reloadData()
        }
        //addressesTable.reloadData()
    }
    
    func changeDefault (customerID: Int, addressID: Int, defaultState: Bool)
    {
        self.editVM?.editAddress(target: .editAddress(customerID: customerID, addressID: addressID), parameters:
                                    ["address" : [
                                        "default":!defaultState
                                    ]])
        self.renderAddressView()
    }
    
    func alertButtons(title: String, buttonTitle: String, message: String, handler: @escaping (UIAlertAction?)->Void)
    {
        print("Alert")
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { action in
            handler(action)
        }))
        present(alert, animated: true, completion: nil)
    }
    
// MARK: - IBActions Part

    @IBAction func addNewAddressButtonAction(_ sender: Any)
    {
        print("working")
        let addAddressView = storyboard?.instantiateViewController(withIdentifier: "addaddressVC") as! AddAddressVC
        addAddressView.userID = userID ?? 6810321223958
        addAddressView.flag = 1
        navigationController?.pushViewController(addAddressView, animated: true)
    }
}

// MARK: - Table View Extension

extension AddressVC : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfAddresses?.addresses?.count ?? 1 //userDetails?.customers.first?.addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : AddressesCell = tableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath) as! AddressesCell
        
        cell.cityLabel.text = "\(arrOfAddresses?.addresses?[indexPath.row].city ?? "No City"), \(arrOfAddresses?.addresses?[indexPath.row].address1 ?? "No Address")"
        cell.phoneNumberLabel.text = arrOfAddresses?.addresses?[indexPath.row].phone
        cell.countryLabel.text = arrOfAddresses?.addresses?[indexPath.row].country
        cell.phoneNumberLabel.adjustsFontSizeToFitWidth = true
        
        if arrOfAddresses?.addresses?[indexPath.row].default == true
        {
            cell.checkMarkImage.image = UIImage(systemName: "checkmark.circle.fill")
        }else{
            cell.checkMarkImage.image = UIImage(systemName: "checkmark.circle")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.alertButtons(title: "Select Address", buttonTitle: "Select", message: "Are you sure that you want to make this your Default address", handler: {action in
            print("select address")
            if self.arrOfAddresses?.addresses?[indexPath.row].default == true
            {
                self.changeDefault(customerID: self.userDetails?.customers.first?.id ?? 6810321223958, addressID: self.arrOfAddresses?.addresses?[indexPath.row].id ?? 0, defaultState: true)
            }
            
            else if self.arrOfAddresses?.addresses?[indexPath.row].default == false
            {
                self.changeDefault(customerID: self.userDetails?.customers.first?.id ?? 6810321223958, addressID: self.arrOfAddresses?.addresses?[indexPath.row].id ?? 0, defaultState: false)
            }
            self.renderAddressView()
        })
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
        
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
// Edit
        let editButton = UITableViewRowAction(style: .default, title: "Edit", handler: {(rowAction, indexPath) in
            print("Edit")
            self.alertButtons(title: "Edit Address", buttonTitle: "Edit", message: "Are you sure that you want to Edit this saved address!", handler: {action in
                print("edit address")
                let addAddressView = self.storyboard?.instantiateViewController(withIdentifier: "addaddressVC") as! AddAddressVC
                addAddressView.userID = self.userID ?? 6810321223958
                addAddressView.flag = 2
                addAddressView.address = self.arrOfAddresses?.addresses?[indexPath.row]
                
                self.navigationController?.pushViewController(addAddressView, animated: true)
            })
        })
        editButton.backgroundColor = UIColor.systemBlue
        
// Delete
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: {(rowAction, indexPath) in
            print("Delete")
            if self.arrOfAddresses?.addresses?[indexPath.row].default == false
            {
                self.alertButtons(title: "Delete Address", buttonTitle: "Delete", message: "Are you sure that you want to Delete this saved address!", handler: {action in
                    self.deleteVM?.deleteAddress(target: .deleteAddress(customerID: self.userDetails?.customers.first?.id ?? 6810321223958, addressID: self.arrOfAddresses?.addresses?[indexPath.row].id ?? 9050959642902))
                    print("delete address")
                    self.arrOfAddresses?.addresses?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                })
            }
            
            else if self.arrOfAddresses?.addresses?[indexPath.row].default == true
            {
                //self.alertButtons(title: "Can't Delete", buttonTitle: "Cancel", message: "Sorry you can't delete your default address", handler: nil)
                let alert = UIAlertController(title: "Delete Unavailable", message: "Sorry you can't delete your default address", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true, completion: nil)
            }
        })
        deleteButton.backgroundColor = UIColor.systemRed
        return [editButton, deleteButton]
    }
}
