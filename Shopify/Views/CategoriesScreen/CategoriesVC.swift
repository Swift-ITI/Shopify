//
//  CategoriesViewController.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit


class CategoriesVC: UIViewController {

    @IBOutlet weak var catiroriesSegmentes: UISegmentedControl!
    @IBOutlet weak var productsCollectionView: UICollectionView!{didSet{productsCollectionView.layer.cornerRadius = CGFloat(20)}}
    @IBOutlet weak var subCategory: Floaty!
    
    var products : Products?
    var catigoriesViewModel : CatigoriesViewModel?
    var flag : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBarButtonItems()
        
        let nib = UINib(nibName: "ProductCVCell", bundle: nil)
        productsCollectionView.register(nib, forCellWithReuseIdentifier: "productCell")
        
        catigoriesViewModel = CatigoriesViewModel()
        catigoriesViewModel?.getProducts(target: .allProducts)
        catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
            self.renderView()
        }
        
        addIconsToFloatingActionBtn()
    }
    
    
    @IBAction func selectedCategories(_ sender: Any) {
        switch catiroriesSegmentes.selectedSegmentIndex{
        case 0 :
            flag = 1
            catigoriesViewModel?.getProducts(target: .catigoriesProducts(id: CatigoryID.kids.id))
            catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
                self.renderView()
            }
        case 1 :
            flag = 2
            catigoriesViewModel?.getProducts(target: .catigoriesProducts(id: CatigoryID.men.id))
            catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
                self.renderView()
            }
        case 2 :
            flag = 3
            catigoriesViewModel?.getProducts(target: .catigoriesProducts(id: CatigoryID.sale.id))
            catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
                self.renderView()
            }
        case 3 :
            flag = 4
            catigoriesViewModel?.getProducts(target: .catigoriesProducts(id: CatigoryID.women.id))
            catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
                self.renderView()
            }
        default : break
        }
    }
    
    func renderView () {
        DispatchQueue.main.async {
            self.products = self.catigoriesViewModel?.DataOfProducts
            self.productsCollectionView.reloadData()
        }
    }
    
    func addIconsToFloatingActionBtn(){
        
        subCategory.addItem(icon: UIImage(named: "shoes")) { _ in
            switch self.flag {
            case 0 :
                self.filter(flag: self.flag, target: .shoes(id:""))
                
            case 1 :
                self.filter(flag: self.flag, target: .shoes(id:CatigoryID.kids.id))
                
            case 2 :
                self.filter(flag: self.flag, target: .shoes(id:CatigoryID.men.id))
                
            case 3 :
                self.filter(flag: self.flag, target: .shoes(id:CatigoryID.sale.id))
            case 4 :
                self.filter(flag: self.flag, target: .shoes(id:CatigoryID.women.id))
            default : break
                

            }
            
        }
        subCategory.addItem(icon: UIImage(named: "T-shirt")) { _ in
            switch self.flag {
            case 0 :
                self.filter(flag: self.flag, target: .tshirts(id:""))
                
            case 1 :
                self.filter(flag: self.flag, target: .tshirts(id:CatigoryID.kids.id))
                
            case 2 :
                self.filter(flag: self.flag, target: .tshirts(id:CatigoryID.men.id))
                
            case 3 :
                self.filter(flag: self.flag, target: .tshirts(id:CatigoryID.sale.id))
            case 4 :
                self.filter(flag: self.flag, target: .tshirts(id:CatigoryID.women.id))
            default : break

            }
            
        }
        subCategory.addItem(icon: UIImage(named: "accesserios")) { _ in
            switch self.flag {
            case 0 :
                self.filter(flag: self.flag, target: .accessories(id:""))
                
            case 1 :
                self.filter(flag: self.flag, target: .accessories(id:CatigoryID.kids.id))
                
            case 2 :
                self.filter(flag: self.flag, target: .accessories(id:CatigoryID.men.id))
                
            case 3 :
                self.filter(flag: self.flag, target: .accessories(id:CatigoryID.sale.id))
            case 4 :
                self.filter(flag: self.flag, target: .accessories(id:CatigoryID.women.id))
            default : break

            }
        }
        
        self.view.addSubview(subCategory)
    }
    
    func filter (flag : Int , target : EndPoints) {
        switch flag {
        case 0 :
            self.catigoriesViewModel?.getProducts(target:target)
            self.catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
                self.renderView()
            }
        case 1 :
            self.catigoriesViewModel?.getProducts(target: target)
            self.catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
                self.renderView()
            }
        case 2 :
            self.catigoriesViewModel?.getProducts(target: target)
            self.catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
                self.renderView()
            }
        case 3 :
            self.catigoriesViewModel?.getProducts(target: target)
            self.catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
                self.renderView()
            }
        case 4 :
            self.catigoriesViewModel?.getProducts(target: target)
            self.catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
                self.renderView()
            }
        default : break
            
        }
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
}
//MARK: extension1
extension CategoriesVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "HomeSB", bundle: nil)
        let prodetailsobj = storyBoard.instantiateViewController(withIdentifier: "productdetails") as! ProductDetailsVC
        
        prodetailsobj.detailedProduct = products?.products[indexPath.row]
        
        self.navigationController?.pushViewController(prodetailsobj, animated: true)
    }
}

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCVCell
        
        productCell.nameOfProduct.text = products?.products[indexPath.row].title
        productCell.priceOfProduct.text = products?.products[indexPath.row].variants?[0].price
        productCell.imgOfProduct.kf.setImage(with: URL(string: products?.products[indexPath.row].image?.src ?? ""))
        
        return productCell
    }
}

//MARK: extension3
extension CategoriesVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: productsCollectionView.layer.frame.size.width/2 - 5, height: productsCollectionView.layer.frame.size.height/3 - 5)
    }
}
