//
//  ProductsVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import UIKit

class ProductsVC: UIViewController {
    
    @IBOutlet weak var ProductCV: UICollectionView!
    
    @IBOutlet weak var pulldown: UIButton!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productfilter()
        searchbar.delegate = self
        ProductCV.delegate = self
        ProductCV.dataSource = self
        
        let nib = UINib(nibName: "ProductCVCell", bundle: nil)
        ProductCV.register(nib, forCellWithReuseIdentifier: "productCell")

    }
  
    @objc func productfilter()
    {
        let c = {(action : UIAction) in
                }
        self.pulldown.menu = UIMenu( title : "" ,children: [
            UIAction(title: "Sort by price", handler: c),
            UIAction(title: "Sort by name", handler: c)])
        pulldown.showsMenuAsPrimaryAction = true
    // pulldown.changesSelectionAsPrimaryAction = true
    }

    
}
extension ProductsVC : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
extension ProductsVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prodetailsobj = self.storyboard?.instantiateViewController(withIdentifier: "productdetails") as! ProductDetailsVC
        self.navigationController?.pushViewController(prodetailsobj, animated: true)
    }
}
extension ProductsVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCVCell
        return cell
    }
    
    
}
extension ProductsVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ProductCV.layer.frame.size.width/2 - 5, height: ProductCV.layer.frame.size.height/3 - 5)
    
        }
}
