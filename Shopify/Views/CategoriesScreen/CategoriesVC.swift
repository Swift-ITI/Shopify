//
//  CategoriesViewController.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit
import Floaty


class CategoriesVC: UIViewController {

    @IBOutlet weak var catiroriesSegmentes: UISegmentedControl!
    @IBOutlet weak var productsCollectionView: UICollectionView!{didSet{productsCollectionView.layer.cornerRadius = CGFloat(20)}}
    @IBOutlet weak var subCategory: Floaty!
    
    var products : Products?
    var catigoriesViewModel : CatigoriesViewModel?
    var flag : Int = 0
    var subflag : Int = 0
    
    var nsDefault = UserDefaults()
    
    var favVMobj : FavCoreDataViewModel?
    var favobj : FavCoreDataManager?
    
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
        
        favVMobj = FavCoreDataViewModel()
        favobj = favVMobj?.getfavInstance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productsCollectionView.reloadData()
    }
    
    
    @IBAction func selectedCategories(_ sender: Any) {
        switch catiroriesSegmentes.selectedSegmentIndex{
        case 0 :
            flag = 1
            switch subflag{
            case 1:
                filter(target: .shoes(id: CatigoryID.kids.id))
            case 2:
                filter(target: .tshirts(id: CatigoryID.kids.id))
                
            case 3:
                filter(target:.accessories(id: CatigoryID.kids.id))
                
            default:
                filter(target: .catigoriesProducts(id: CatigoryID.kids.id))
            }
            
        case 1 :
            flag = 2
            switch subflag{
            case 1:
                filter(target: .shoes(id: CatigoryID.men.id))
            case 2:
                filter(target: .tshirts(id: CatigoryID.men.id))
                
            case 3:
                filter(target:.accessories(id: CatigoryID.men.id))
                
            default:
                filter(target: .catigoriesProducts(id: CatigoryID.men.id))
            }
          
        case 2 :
            flag = 3
            switch subflag{
            case 1:
                filter(target: .shoes(id: CatigoryID.sale.id))
            case 2:
                filter(target: .tshirts(id: CatigoryID.sale.id))
                
            case 3:
                filter(target:.accessories(id: CatigoryID.sale.id))
                
            default:
                filter(target: .catigoriesProducts(id: CatigoryID.sale.id))
            }
           
        case 3 :
            flag = 4
            switch subflag{
            case 1:
                filter(target: .shoes(id: CatigoryID.women.id))
            case 2:
                filter(target: .tshirts(id: CatigoryID.women.id))
                
            case 3:
                filter(target:.accessories(id: CatigoryID.women.id))
                
            default:
                filter(target: .catigoriesProducts(id: CatigoryID.women.id))
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
            self.subflag = 1
            switch self.flag {
            case 0 :
                self.filter(target: .shoes(id:""))
                
            case 1 :
                self.filter(target: .shoes(id:CatigoryID.kids.id))
                
            case 2 :
                self.filter(target: .shoes(id:CatigoryID.men.id))
                
            case 3 :
                self.filter(target: .shoes(id:CatigoryID.sale.id))
            case 4 :
                self.filter(target: .shoes(id:CatigoryID.women.id))
            default : break
                

            }
            
        }
        subCategory.addItem(icon: UIImage(named: "T-shirt")) { _ in
            self.subflag = 2
            switch self.flag {
            case 0 :
                self.filter( target: .tshirts(id:""))
                
            case 1 :
                self.filter(target: .tshirts(id:CatigoryID.kids.id))
                
            case 2 :
                self.filter(target: .tshirts(id:CatigoryID.men.id))
                
            case 3 :
                self.filter(target: .tshirts(id:CatigoryID.sale.id))
            case 4 :
                self.filter(target: .tshirts(id:CatigoryID.women.id))
            default : break

            }
            
        }
        subCategory.addItem(icon: UIImage(named: "accesserios")) { _ in
            self.subflag = 3
            switch self.flag {
            case 0 :
                self.filter(target: .accessories(id:""))
                
            case 1 :
                self.filter(target: .accessories(id:CatigoryID.kids.id))
                
            case 2 :
                self.filter(target: .accessories(id:CatigoryID.men.id))
                
            case 3 :
                self.filter(target: .accessories(id:CatigoryID.sale.id))
            case 4 :
                self.filter(target: .accessories(id:CatigoryID.women.id))
            default : break

            }
        }
        
        self.view.addSubview(subCategory)
    }
    
    func filter (target: EndPoints)
    {
        self.catigoriesViewModel?.getProducts(target:target)
        self.catigoriesViewModel?.bindResultOfCatigoriesToCatigorieViewController = { () in
            self.renderView()
        }
    }
    
    func addBarButtonItems(){
        let fav = UIBarButtonItem(image: UIImage(systemName: "heart"),style: .plain , target: self, action: #selector(navfav))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "CoffeeColor")
        
        let cart = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(navcart))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "CoffeeColor")
        
        navigationItem.rightBarButtonItems = [fav , cart]
        
        let search =  UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(navsearch))
         self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "CoffeeColor")
         navigationItem.leftBarButtonItem = search
        
    }
    
    @objc func navfav()
    {
        if !nsDefault.bool(forKey: "isLogged"){
         showAlert(title: "Sorry", msg: "Please Sign in or Register to get full access") { _ in
             let logInObj = UIStoryboard(name: "AuthenticationSB", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
             self.navigationController?.pushViewController(logInObj, animated: true)
           
         }
        }else{
            let FavouriteStoryBoardd = UIStoryboard(name: "ProfileSB", bundle: nil)
            let favobj = FavouriteStoryBoardd.instantiateViewController(withIdentifier: "wishlistseemoreVC") as! WishListSeeMoreVC
            self.navigationController?.pushViewController(favobj, animated: true)
        }
        
    }
    @objc func navcart()
    {
        if (nsDefault.value(forKey: "isLogged") as? Bool) ?? false{
          
            let CartStoryBoard = UIStoryboard(name: "OthersSB", bundle: nil)
            let cartobj =
            CartStoryBoard.instantiateViewController(withIdentifier: "cartid") as! CartVC
            self.navigationController?.pushViewController(cartobj, animated: true)
            
        }else{
            showAlert(title: "Sorry", msg: "Please Sign in or Register to get full access") { _ in
                let logInObj = UIStoryboard(name: "AuthenticationSB", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
                self.navigationController?.pushViewController(logInObj, animated: true)
            }
        }
    }
    @objc func navsearch()
    {
        let searchobj = UIStoryboard(name: "HomeSB", bundle: nil).instantiateViewController(withIdentifier: "productsid") as! ProductsVC
        navigationController?.pushViewController(searchobj, animated: true)
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

//MARK: extension2
extension CategoriesVC:  UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCVCell
        
        productCell.nameOfProduct.text = products?.products[indexPath.row].title
        productCell.priceOfProduct.text = ("\(CurrencyExchanger.changeCurrency(cash: products?.products[indexPath.row].variants?[0].price ?? ""))\(nsDefault.value(forKey: "CashType") ?? "")")
        productCell.imgOfProduct.kf.setImage(with: URL(string: products?.products[indexPath.row].image?.src ?? ""))
        
        if (favobj?.isFav(lineItemId: products?.products[indexPath.row].id ?? 0))! {
            productCell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
            productCell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            
           
        }
      
        productCell.heartBtn.tag = indexPath.row
        productCell.heartBtn.addTarget(self, action: #selector(clickHeart(_:)), for: .touchUpInside)
        
        return productCell
    }
    
    @objc func clickHeart(_ sender: UIButton) {
        
        if !((nsDefault.value(forKey: "isLogged") as? Bool) ?? false) {
            showAlert(title: "Sorry", msg: "Please Sign in or Register to get full access") { _ in
                let logInObj = UIStoryboard(name: "AuthenticationSB", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
                self.navigationController?.pushViewController(logInObj, animated: true)
              
            }
        }else{
            if (favobj?.isFav(lineItemId: products?.products[sender.tag].id ?? 0))! {
                
                favobj?.DeleteFromFav(lineitemID: products?.products[sender.tag].id ?? 0)
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            else {
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                
                favobj?.SaveFavtoCoreData(draftOrderID: 0, productID: products?.products[sender.tag].id ?? 0, title: products?.products[sender.tag].title ?? "", price: products?.products[sender.tag].variants?[0].price ?? "", quantity: 1, img: products?.products[sender.tag].image?.src ?? "")
                
              
            }
            self.productsCollectionView.reloadData()
            
        }
        
      
    }
    
    
}

//MARK: extension3
extension CategoriesVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: productsCollectionView.layer.frame.size.width/2 - 5, height: productsCollectionView.layer.frame.size.height/3 - 5)
    }
}

extension CategoriesVC {
    func showAlert(title: String, msg: String, handler: @escaping (UIAlertAction?) -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in handler(action) }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            () }))
        present(alert, animated: true, completion: nil)
    }
}
