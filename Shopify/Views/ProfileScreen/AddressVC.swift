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
        userVM?.fetchAddresses(target: .searchCustomerAddresses(id: userID ?? 6810321223958))
        userVM?.bindAddressToVC = { () in self.renderAddressView()
            self.addressesTable.reloadData()
            
        }
        //addressesTable.reloadData()
//        self.renderAddressView()
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
// alert Part
        
        let alert : UIAlertController = UIAlertController(title: "Address Interaction", message: "Please Select if you want to Edit Address or Select Address to be your Default", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
//edit part
        
        alert.addAction(UIAlertAction(title: "Edit Address", style: .default, handler: {action in
            print("edit address")
            let addAddressView = self.storyboard?.instantiateViewController(withIdentifier: "addaddressVC") as! AddAddressVC
            addAddressView.userID = self.userID ?? 6810321223958
            addAddressView.flag = 2
            addAddressView.address = self.arrOfAddresses?.addresses?[indexPath.row]
            
            self.navigationController?.pushViewController(addAddressView, animated: true)
        }))
        
// select part
        
        alert.addAction(UIAlertAction(title: "Select Address", style: .default, handler: {action in
            print("select address")
            if self.arrOfAddresses?.addresses?[indexPath.row].default == true
            {
                self.editVM?.editAddress(target: .editAddress(customerID: self.userDetails?.customers.first?.id ?? 6810321223958, addressID: self.arrOfAddresses?.addresses?[indexPath.row].id ?? 0), parameters:
                                        ["address" : [
                                            "default":false
                                        ]])
                
                self.renderAddressView()
                //self.addressesTable.reloadData()
            }
            
            else if self.arrOfAddresses?.addresses?[indexPath.row].default == false
            {
                self.editVM?.editAddress(target: .editAddress(customerID: self.userDetails?.customers.first?.id ?? 6810321223958, addressID: self.arrOfAddresses?.addresses?[indexPath.row].id ?? 0), parameters:
                                        ["address" : [
                                            "default":true
                                        ]])
                self.renderAddressView()
                //self.addressesTable.reloadData()
            }
            
            self.renderAddressView()
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
                self.deleteVM?.deleteAddress(target: .deleteAddress(customerID: self.userDetails?.customers.first?.id ?? 6810321223958, addressID: self.arrOfAddresses?.addresses?[indexPath.row].id ?? 9050959642902))
                print("delete address")
                self.arrOfAddresses?.addresses?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }))
            self.present(alerts, animated: true, completion: nil)
            //addressesTable.reloadData()
        }
        //addressesTable.reloadData()
    }
}
