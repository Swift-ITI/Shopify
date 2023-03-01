//
//  ProductDetailsVC.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit
import Cosmos

class ProductDetailsVC: UIViewController {
    private var flag : Bool = false
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var productprice: UILabel!
    @IBOutlet weak var pulldowncolor: UIButton!
    @IBOutlet weak var pulldownsize: UIButton!
    @IBOutlet weak var ItemCV: UICollectionView!
    @IBOutlet var reviewTableView: UITableView!
    @IBOutlet weak var productdescription: UITextView!
    //@IBOutlet weak var descriptionLabel: UILabel!
    //@IBOutlet var reviewLabel: UILabel!
    @IBOutlet weak var favbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ItemCV.layer.borderWidth = 2
        ItemCV.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        ItemCV.layer.masksToBounds = true
        ItemCV.layer.cornerRadius = 15
     
        
        productfilter(sender: pulldownsize)
        productfilter(sender: pulldowncolor)
        
        ItemCV.delegate = self
        ItemCV.dataSource = self
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.layer.borderColor = UIColor(named:"CoffeeColor")?.cgColor
        reviewTableView.layer.borderWidth = 1.5
        reviewTableView.layer.cornerRadius = 20
        
        let nib = UINib(nibName: "BrandCVCell", bundle: nil)
        ItemCV.register(nib,forCellWithReuseIdentifier: "offerbrandcell")
        
        let nibT = UINib(nibName: "ReviewTVCell", bundle: nil)
        reviewTableView.register(nibT, forCellReuseIdentifier: "reviewTVCell")
        
        
//        descriptionLabel.layer.cornerRadius = 15
//        descriptionLabel.layer.masksToBounds = true
 //       descriptionLabel.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
  //      reviewLabel.layer.cornerRadius = 15
  //      reviewLabel.layer.masksToBounds = true
  //      reviewLabel.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
    }
    
    @IBAction func addtocart(_ sender: Any) {
    }
    
    @IBAction func addtofavourite(_ sender: Any) {
        if flag == false {
            favbtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            flag = true
        }
        else
        {
            favbtn.setImage(UIImage(systemName: "heart"), for: .normal)
            flag = false
        }
    }
    func productfilter(sender:UIButton)
    {
        switch sender{
        case pulldowncolor:
            let c = {(action : UIAction) in
            }
            pulldowncolor.menu = UIMenu( title : "" ,children: [
                UIAction(title: "Blue", handler: c),
                UIAction(title: "Black", handler: c),
                UIAction(title: "Red",handler: c)])
            self.pulldowncolor.showsMenuAsPrimaryAction = true
        case pulldownsize:
            let c = {(action : UIAction) in
            }
            pulldownsize.menu = UIMenu( title : "" ,children: [
                UIAction(title: "Small", handler: c),
                UIAction(title: "Medium", handler: c),
                UIAction(title: "Large",handler: c)])
            self.pulldownsize.showsMenuAsPrimaryAction = true
            
        default:
            print("no")
        }
    }
    
}

// MARK: - Collection View Extension

extension ProductDetailsVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerbrandcell", for: indexPath) as! BrandCVCell
        return cell
    }
}

extension ProductDetailsVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ItemCV.layer.frame.size.width - 5, height: ItemCV.layer.frame.size.height - 5)
    }
}

// MARK: - Table View Extension

extension ProductDetailsVC : UITableViewDelegate
{
    
}

extension ProductDetailsVC : UITableViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTVCell", for: indexPath) as! ReviewTVCell
       
        
        return cell
    }
}
