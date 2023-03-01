//
//  CategoriesViewController.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit
import Floaty


class CategoriesVC: UIViewController {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var subCategory: Floaty!
    
    var products: [Product]?
    var womenProducts: [Product]?
    var kidsProducts: [Product]?
    var menProducts: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBarButtonItems()

        productsCollectionView.layer.cornerRadius = CGFloat(20)
        //will be comment it after fetch data from api
        products = []
        womenProducts = []
        kidsProducts = []
        menProducts = []

        var product = Product()
        product.nameOfProduct = "accesserios"
        product.priceOfProduct = "20$"
        for _ in 0...10 {
            womenProducts?.append(product)
        }
        products = womenProducts
        
        let nib = UINib(nibName: "ProductCVCell", bundle: nil)
        productsCollectionView.register(nib, forCellWithReuseIdentifier: "productCell")
        
        addIconsToFloatingActionBtn()
    }
    
    func addIconsToFloatingActionBtn(){
        
        subCategory.addItem(icon: UIImage(named: "shoes")) { _ in
            
            var product = Product()
            product.nameOfProduct = "shoes"
            product.priceOfProduct = "50$"
            product.imgOfProuct = "shoes"
            
            for _ in 0...10 {
                self.products?.append(product)
            }
            
            self.productsCollectionView.reloadData()
            
        }
        subCategory.addItem(icon: UIImage(named: "clothes")) { _ in
            
            var product = Product()
            product.nameOfProduct = "clothes"
            product.priceOfProduct = "200$"
            product.imgOfProuct = "clothes"
            
            for _ in 0...10 {
                self.products?.append(product)
            }
            
            self.productsCollectionView.reloadData()
        }
        subCategory.addItem(icon: UIImage(named: "accesserios")) { _ in
            
            var product = Product()
            product.nameOfProduct = "accesseriosaccesseriosaccesseriosaccesserios"
            product.priceOfProduct = "20$"
            product.imgOfProuct = "accesserios"
            
            for _ in 0...10 {
                self.products?.append(product)
            }
            
            self.productsCollectionView.reloadData()
        }
        
        self.view.addSubview(subCategory)
       // self.productsCollectionView.reloadData()
    }
    
    func addBarButtonItems(){
        let fav = UIBarButtonItem(image: UIImage(systemName: "heart"),style: .plain , target: self, action: #selector(navfav))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "BeigeColor")
        
        let cart = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(navcart))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "BeigeColor")
        
        navigationItem.rightBarButtonItems = [fav , cart]
        
        let search =  UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(navsearch))
         self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "BeigeColor")
         navigationItem.leftBarButtonItem = search
        
    }
    
    @objc func navfav()
    {
        let FavouriteStoryBoardd = UIStoryboard(name: "ProfileSB", bundle: nil)
        let favobj = FavouriteStoryBoardd.instantiateViewController(withIdentifier: "wishlistseemoreVC") as! WishListSeeMoreVC
        self.navigationController?.pushViewController(favobj, animated: true)
    }
    @objc func navcart()
    {
        let CartStoryBoard = UIStoryboard(name: "OthersSB", bundle: nil)
        let cartobj =
        CartStoryBoard.instantiateViewController(withIdentifier: "cartid") as! CartVC
        self.navigationController?.pushViewController(cartobj, animated: true)
    }
    @objc func navsearch()
    {
        print("aa")
//        let searchobj = self.storyboard?.instantiateViewController(withIdentifier: "search") as! SearchViewController
//        self.navigationController?.pushViewController(searchobj, animated: true)
    }
    
    @IBAction func ShowWomenFashion(_ sender: Any) {
        
        var product = Product()
        product.nameOfProduct = "Woman"
        product.priceOfProduct = "200$"
        
        for _ in 0...10 {
            womenProducts?.append(product)
        }
        
        self.products = womenProducts
        self.productsCollectionView.reloadData()
    }
    
    
    @IBAction func ShowKidsFashoin(_ sender: Any) {
        
        var product = Product()
        product.nameOfProduct = "kid"
        product.priceOfProduct = "50$"
        
        for _ in 0...10 {
            kidsProducts?.append(product)
        }
        
        self.products = kidsProducts
        self.productsCollectionView.reloadData()
    }
    
    
    @IBAction func ShowMenFashoin(_ sender: Any) {
        
        var product = Product()
        product.nameOfProduct = "man"
        product.priceOfProduct = "100$"
        
        for _ in 0...10 {
            menProducts?.append(product)
        }
        
        self.products = menProducts
        self.productsCollectionView.reloadData()
    }

}
//MARK: extension1
extension CategoriesVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "HomeSB", bundle: nil)
        let prodetailsobj = storyBoard.instantiateViewController(withIdentifier: "productdetails") as! ProductDetailsVC
        self.navigationController?.pushViewController(prodetailsobj, animated: true)
    }
}

//MARK: extension2
extension CategoriesVC:  UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCVCell
        
        productCell.nameOfProduct.text = products?[indexPath.row].nameOfProduct
        productCell.priceOfProduct.text = products?[indexPath.row].priceOfProduct
        productCell.imgOfProduct.image = UIImage(named: products?[indexPath.row].imgOfProuct ?? "No image")
        
        return productCell
    }
}

//MARK: extension3
extension CategoriesVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: productsCollectionView.layer.frame.size.width/2 - 5, height: productsCollectionView.layer.frame.size.height/3 - 5)
        
        //return CGSize(width: (UIScreen.main.bounds.size.width/2) - 30, height: (UIScreen.main.bounds.size.height/4) - 30)
    }
}
