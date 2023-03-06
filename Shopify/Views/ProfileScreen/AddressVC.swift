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
    var userVM : UserViewModel?
    var deleteVM : AddressesFunctions?
    var editVM : AddressesFunctions?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userVM = UserViewModel()
        editVM = AddressesFunctions()
        deleteVM = AddressesFunctions()
        userVM?.fetchUsers(target: .searchCustomerByID(id: userID ?? 6810321223958))
        userVM?.bindDataToVC = { () in self.renderAddressView()
            self.addressesTable.reloadData()}
        addressesTable.reloadData()
        print(userDetails?.customers.first?.addresses?.count ?? 0)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        addressesTable.reloadData()
    }
    
    func renderAddressView()
    {
        DispatchQueue.main.async
        {
            self.userDetails = self.userVM?.users
            print(self.userDetails?.customers.first?.email ?? "none")
            self.addressesTable.reloadData()
        }
        addressesTable.reloadData()
    }
    
// MARK: - IBActions Part

    @IBAction func addNewAddressButtonAction(_ sender: Any)
    {
        print("working")
        /*let addAddressView = storyboard?.instantiateViewController(withIdentifier: "addaddressVC") as! AddAddressVC
        addAddressView.userID = userID ?? 6810321223958
        navigationController?.pushViewController(addAddressView, animated: true)*/
        let addAddressView = storyboard?.instantiateViewController(withIdentifier: "addaddressVC") as! AddAddressVC
        addAddressView.modalPresentationStyle = .fullScreen
        addAddressView.userID = userID ?? 6810321223958
        self.present(addAddressView, animated: true, completion: nil)
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
        return userDetails?.customers.first?.addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : AddressesCell = tableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath) as! AddressesCell
        
        cell.cityLabel.text = "\(userDetails?.customers.first?.addresses?[indexPath.row].city ?? "No City"), \(userDetails?.customers.first?.addresses?[indexPath.row].address1 ?? "No Address")"
        cell.phoneNumberLabel.text = userDetails?.customers.first?.addresses?[indexPath.row].phone
        cell.countryLabel.text = userDetails?.customers.first?.addresses?[indexPath.row].country
        
        if ((userDetails?.customers.first?.addresses?[indexPath.row].default) != false)
        {
            cell.checkMarkImage.image = UIImage(named: "checkmark.circle.fill")
            cell.checkMarkImage.image = UIImage(systemName: "checkmark.circle.fill")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
// alert Part
        
        let alert : UIAlertController = UIAlertController(title: "Address Interaction", message: "Please Select if you want to Edit Address or Select Address to be your Default", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
//edit part
        
        alert.addAction(UIAlertAction(title: "Edit Address", style: .default, handler: {action in
            print("edit address")
            let addAddressView = self.storyboard?.instantiateViewController(withIdentifier: "addaddressVC") as! AddAddressVC
            addAddressView.userID = self.userID ?? 6810321223958
            addAddressView.addressID = self.userDetails?.customers.first?.addresses?[indexPath.row].id ?? 0
            addAddressView.addressesData = ["\(self.userDetails?.customers.first?.addresses?[indexPath.row].city ?? "No City")", "\(self.userDetails?.customers.first?.addresses?[indexPath.row].country ?? "No Country")", "\(self.userDetails?.customers.first?.addresses?[indexPath.row].address1 ?? "No Address")", "\(self.userDetails?.customers.first?.addresses?[indexPath.row].phone ?? "No Phone")"]
            //self.navigationController?.pushViewController(addAddressView, animated: true)
            addAddressView.modalPresentationStyle = .fullScreen
            self.present(addAddressView, animated: true, completion: nil)
        }))
        
// select part
        
        alert.addAction(UIAlertAction(title: "Select Address", style: .default, handler: {action in
            print("select address")
            if ((self.userDetails?.customers.first?.addresses?[indexPath.row].default) != false)
            {
                self.editVM?.putCode(target: .editAddress(customerID: self.userDetails?.customers.first?.id ?? 6810321223958, addressID: self.userDetails?.customers.first?.addresses?[indexPath.row].id ?? 0), parameters:
                                        ["address" : [
                                            "default":false
                                        ]])
            }
            
            else if ((self.userDetails?.customers.first?.addresses?[indexPath.row].default) != true)
            {
                self.editVM?.putCode(target: .editAddress(customerID: self.userDetails?.customers.first?.id ?? 6810321223958, addressID: self.userDetails?.customers.first?.addresses?[indexPath.row].id ?? 0), parameters:
                                        ["address" : [
                                            "default":true
                                        ]])
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        //tableView.reloadData()
        if editingStyle == .delete
        {
            let alerts : UIAlertController = UIAlertController(title: "Delete Address ?", message: "Are you sure that you want to delete this saved address !", preferredStyle: .alert)
            alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alerts.addAction(UIAlertAction(title: "Delete", style: .default, handler: {action in
                self.deleteVM?.deleteCode(target: .deleteAddress(customerID: self.userDetails?.customers.first?.id ?? 6810321223958, addressID: self.userDetails?.customers.first?.addresses?[indexPath.row].id ?? 9050959642902))
                print("delete address")
            }))
            self.present(alerts, animated: true, completion: nil)
            //addressesTable.reloadData()
        }
        //addressesTable.reloadData()
    }
}
