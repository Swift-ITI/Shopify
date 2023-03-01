//
//  ViewController.swift
//  Shopify
//
//  Created by Adham Samer on 17/02/2023.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {
    
    var Brandviewmodel : BrandViewModel?
    var BrandCollectionviewresponse : Brands?
    
    var Offerviewmodel : OfferViewModel?
    var OfferCollectionviewresponse : Discounts?
    
    var arrayofimg = [UIImage(named: "coupon"),UIImage(named: "sale")]
    var timer : Timer?
    var currentcellindex = 0
    
    
    @IBOutlet weak var pagecontroller: UIPageControl!
    
    @IBOutlet weak var OfferCV: UICollectionView!{
        didSet{
            OfferCV.delegate = self
            OfferCV.dataSource = self
            OfferCV.layer.cornerRadius = 20
            OfferCV.layer.borderWidth = 5
            OfferCV.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        }
    }
    @IBOutlet weak var BrandsCV: UICollectionView!{
        didSet{
            BrandsCV.dataSource = self
            BrandsCV.delegate = self
            BrandsCV.layer.cornerRadius = 20
            BrandsCV.layer.borderWidth = 5
            BrandsCV.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        Brandviewmodel = BrandViewModel()
        Brandviewmodel?.getdata(url: "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01/smart_collections.json")
        Brandviewmodel?.bindResultOfBrandsToHomeViewController = { () in
            DispatchQueue.main.async {
                self.BrandCollectionviewresponse = self.Brandviewmodel?.DataOfBrands
                self.BrandsCV.reloadData()
            }
            
        }
        self.BrandsCV.reloadData()
        let nib = UINib(nibName: "BrandCVCell", bundle: nil)
        OfferCV.register(nib,forCellWithReuseIdentifier: "offerbrandcell")
        BrandsCV.register(nib, forCellWithReuseIdentifier: "offerbrandcell")
        
        Offerviewmodel = OfferViewModel()
        Offerviewmodel?.getoffer(url: "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01/price_rules/1380100899094/discount_codes.json")
        Offerviewmodel?.bindResultOfOffersToHomeViewController = { () in
            DispatchQueue.main.async {
                self.OfferCollectionviewresponse = self.Offerviewmodel?.DataOfOffers
                self.OfferCV.reloadData()
            }
        }
        addBarButtonItems()
        startTimer()
        pagecontroller.numberOfPages = arrayofimg.count
    }

    func startTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(movetonext), userInfo: nil, repeats: true)
    }
    
    @objc func movetonext()
    {
        if currentcellindex < arrayofimg.count - 1
        {
            currentcellindex += 1
        }
        else
        {
            currentcellindex = 0
        }
        OfferCV.scrollToItem(at: IndexPath(item: currentcellindex, section: 0), at: .centeredHorizontally, animated: true)
        pagecontroller.currentPage = currentcellindex
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
        
extension HomeVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case OfferCV:
            return arrayofimg.count
            case BrandsCV:
            return BrandCollectionviewresponse?.smart_collections.count ?? 0
            default:
                return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case OfferCV:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerbrandcell", for: indexPath) as! BrandCVCell
            cell.offerbrandimg.image = arrayofimg[indexPath.row]
            return cell
            
            case BrandsCV:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerbrandcell", for: indexPath) as! BrandCVCell
            cell.offerbrandimg.kf.setImage(with: URL(string: BrandCollectionviewresponse?.smart_collections[indexPath.row].image.src ?? ""),placeholder: UIImage(named: "loading.png"), options: [.keepCurrentImageWhileLoading], progressBlock: nil, completionHandler: nil)
                cell.layer.cornerRadius = 20
                cell.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
                cell.layer.borderWidth = 2
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                return cell
        }
    }

}
extension HomeVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case BrandsCV:
                let productobj : ProductsVC = self.storyboard?.instantiateViewController(withIdentifier: "productsid") as! ProductsVC
                self.navigationController?.pushViewController(productobj, animated: true)
            default:
                break
        }
    }
}

extension HomeVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case OfferCV:
                return CGSize(width: OfferCV.layer.frame.size.width - 16, height: OfferCV.layer.frame.size.height - 20)
            case BrandsCV:
                return CGSize(width: BrandsCV.layer.frame.size.width/2 - 16, height: BrandsCV.layer.frame.size.height/2 - 10)
            default:
                return CGSize(width: (UIScreen.main.bounds.size.width/2) - 50, height: (UIScreen.main.bounds.size.height/6) - 10)
        }
        
    }
}
