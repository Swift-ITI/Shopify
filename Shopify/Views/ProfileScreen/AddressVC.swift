//
//  AddressVC.swift
//  Shopify
//
//  Created by Michael Hany on 25/02/2023.
//

import UIKit

class AddressVC: UIViewController
{

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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        addNewAddressButton.layer.masksToBounds = true
        addNewAddressButton.layer.cornerRadius = addNewAddressButton.frame.width/18
    }

    @IBAction func addNewAddressButtonAction(_ sender: Any)
    {
        print("working")
    }
}

extension AddressVC : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : AddressesCell = tableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath) as! AddressesCell
        
        return cell
    }
    
}
