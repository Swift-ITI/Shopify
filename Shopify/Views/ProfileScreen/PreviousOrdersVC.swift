//
//  PreviousOrdersVC.swift
//  Shopify
//
//  Created by Zeinab on 26/02/2023.
//

import UIKit

class PreviousOrdersVC: UIViewController {

    var userID : Int?
    var orders : [Order]?
    var productsNumber: Int?
    @IBOutlet weak var ordersTableView: UITableView! {
        didSet {
            ordersTableView.delegate = self
            ordersTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsNumber = orders?.count ?? 0
        let orderCellNib = UINib(nibName: "OrdersCell", bundle: nil)
        ordersTableView.register(orderCellNib, forCellReuseIdentifier: "orderCell")
    }
}

// MARK: - Table View Extension

extension PreviousOrdersVC : UITableViewDelegate {}
extension PreviousOrdersVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsNumber ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : OrdersCell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrdersCell
        
        cell.priceLabel.text = orders?[indexPath.row].current_total_price
        cell.dateLabel.text = orders?[indexPath.row].created_at
        cell.itemsNumberLabel.text = "\(orders?[indexPath.row].line_items?.count ?? 0)"
        return cell
    }
}
