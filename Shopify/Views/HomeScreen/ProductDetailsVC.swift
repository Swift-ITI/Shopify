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
    @IBOutlet weak var productdescription: UITextView!
    @IBOutlet weak var DescriptionLabel: UILabel!
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
        
        let nib = UINib(nibName: "BrandCVCell", bundle: nil)
        ItemCV.register(nib,forCellWithReuseIdentifier: "offerbrandcell")
        
        
        DescriptionLabel.layer.cornerRadius = 15
        DescriptionLabel.layer.masksToBounds = true
        DescriptionLabel.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
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
