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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userVM = UserViewModel()
        userVM?.fetchUsers(target: .searchCustomerByID(id: userID ?? 6810321223958))
        userVM?.bindDataToVC = { () in self.renderAddressView()
            self.addressesTable.reloadData()}
        addressesTable.reloadData()
        print(userDetails?.customers.first?.addresses?.count ?? 0)
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
        let addAddressView = storyboard?.instantiateViewController(withIdentifier: "addaddressVC") as! AddAddressVC
        addAddressView.userID = userID ?? 6810321223958
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
        return userDetails?.customers.first?.addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : AddressesCell = tableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath) as! AddressesCell
        
        cell.cityLabel.text = "\(userDetails?.customers.first?.addresses?[indexPath.row].city ?? "No City"), \(userDetails?.customers.first?.addresses?[indexPath.row].address1 ?? "No Address")"
        cell.phoneNumberLabel.text = userDetails?.customers.first?.addresses?[indexPath.row].phone
        cell.countryLabel.text = userDetails?.customers.first?.addresses?[indexPath.row].country
        
        if ((userDetails?.customers.first?.addresses?[indexPath.row].default) != nil)
        {
            //heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.checkMarkImage.image = UIImage(named: "checkmark.circle.fill")
            cell.checkMarkImage.image = UIImage(systemName: "checkmark.circle.fill")
        }
        
        return cell
    }
    
}
