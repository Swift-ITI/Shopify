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
    
    @IBOutlet weak var price: UILabel!
    
    var brandId : String?
    var Brandproductviewmodel : BrandproductsViewModel?
    var BrandproudctResponse : Products?
    var titles : [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // productfilter()
        searchbar.delegate = self
        ProductCV.delegate = self
        ProductCV.dataSource = self
        
        
        
        let nib = UINib(nibName: "ProductCVCell", bundle: nil)
        ProductCV.register(nib, forCellWithReuseIdentifier: "productCell")

        Brandproductviewmodel = BrandproductsViewModel()
        Brandproductviewmodel?.getBrandProducts(target: EndPoints.brandproducts(id: brandId ?? ""))
        Brandproductviewmodel?.bindResultOfBrandproductToProductdetailsViewController = {
            DispatchQueue.main.async {
                self.BrandproudctResponse = self.Brandproductviewmodel?.DataOfBrandProduct
                self.titles = self.BrandproudctResponse?.products
                self.ProductCV.reloadData()
            }
        }
        
    }
    
    
 
    @IBAction func slider(_ sender: UISlider)
    {
        titles = []
        if (sender.value) == 0
        {
            titles = BrandproudctResponse?.products
        }
        for pricee in BrandproudctResponse?.products ?? []
        {
            if Double(pricee.variants?[0].price ?? "" ) ?? 0 < Double(sender.value)
            {
                titles?.append(pricee)
            }
        }
        ProductCV.reloadData()
        price.text = String(Int(sender.value))
    }
    
   /* @objc func productfilter()
    {
        let c = {(action : UIAction) in
                }
        self.pulldown.menu = UIMenu( title : "" ,children: [
            UIAction(title: "Sort by price", handler: c),
            UIAction(title: "Sort by name", handler: c)])
        pulldown.showsMenuAsPrimaryAction = true
    // pulldown.changesSelectionAsPrimaryAction = true
    }*/

    
}
extension ProductsVC : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        titles = []
        
        if searchText == ""
        {
            titles = BrandproudctResponse?.products
        }
        for word in BrandproudctResponse?.products ?? []
        {
            if word.title.uppercased().contains(searchText.uppercased())
            {
                titles?.append(word)
            }
        }
        ProductCV.reloadData()
    }
}
extension ProductsVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prodetailsobj = self.storyboard?.instantiateViewController(withIdentifier: "productdetails") as! ProductDetailsVC
        prodetailsobj.detailedProduct = BrandproudctResponse?.products[indexPath.row]
        self.navigationController?.pushViewController(prodetailsobj, animated: true)
    }
}
extension ProductsVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCVCell
        cell.nameOfProduct.text = titles?[indexPath.row].title
        cell.priceOfProduct.text = titles?[indexPath.row].variants?[0].price
        cell.imgOfProduct.kf.setImage(with: URL(string: titles?[indexPath.row].image?.src ?? ""))
        return cell
    }
    
    
}
extension ProductsVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ProductCV.layer.frame.size.width/2 - 5, height: ProductCV.layer.frame.size.height/3 - 5)
    
        }
}
