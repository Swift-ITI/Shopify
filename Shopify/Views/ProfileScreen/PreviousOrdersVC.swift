//
//  PreviousOrdersVC.swift
//  Shopify
//
//  Created by Zeinab on 26/02/2023.
//

import UIKit

class PreviousOrdersVC: UIViewController {

    var productsNumber: Int = 10
    @IBOutlet weak var ordersTableView: UITableView! {
        didSet {
            ordersTableView.delegate = self
            ordersTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let orderCellNib = UINib(nibName: "OrdersCell", bundle: nil)
        ordersTableView.register(orderCellNib, forCellReuseIdentifier: "orderCell")
    }
}

extension PreviousOrdersVC : UITableViewDelegate {}
extension PreviousOrdersVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : OrdersCell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrdersCell
            cell.priceLabel.text = "1234 $"
            cell.dateLabel.text = "13 - 03 - 2023 12:00 PM"
            return cell
    }
}
