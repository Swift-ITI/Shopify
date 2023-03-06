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
    
    var arrayofimg : [String]?
    var arrayofimg2 : [String]? = ["https://www.citypng.com/public/uploads/preview/hd-discount-30-percent-off-sale-red-badge-png-31632100045jywzxxkjkw.png","https://www.citypng.com/public/uploads/preview/30-percent-off-sale-sign-logo-hd-png-116676817578j6ock9fz6.png","https://www.citypng.com/public/uploads/preview/30-off-tag-red-label-sign-logo-hd-png-116682074589jvh3p0irr.png","https://www.citypng.com/public/uploads/preview/discount-30-percent-text-logo-sign-black-png-image-11668096874eu6qfscms5.png","https://www.pngall.com/wp-content/uploads/13/30-Discount-PNG-Image.png","https://pngimage.net/wp-content/uploads/2018/05/discount-logo-png-3.png","https://www.pngitem.com/pimgs/m/685-6852872_grunge-30-percent-label-psd-hd-png-download.png","https://www.citypng.com/public/uploads/preview/free-discount-big-sale-up-to-30-percent-png-11667685843lkrbyewb8h.png","https://images.getpng.net/uploads/preview/sale-discount-icons-special-offer-price-signs-5-10-20-30-40-50-60-70-80-90-percent-off-reduction30-1151634335821ttswcgo3fa.webp","https://mpng.vectorpng.com/20200421/yva/logo-yellow-number-for-discount-tag-5e9eef211bca35.39632767.jpg"]

    var timer : Timer?
    var currentcellindex = 0
    var numberofdots : Int?
    //var arrimg : []?
    
    
    @IBOutlet weak var pagecontroller: UIPageControl!
    
    @IBOutlet weak var OfferCV: UICollectionView!{
        didSet{
            OfferCV.delegate = self
            OfferCV.dataSource = self
            OfferCV.layer.cornerRadius = 20
            OfferCV.layer.borderWidth = 5
            OfferCV.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        }
    }
    @IBOutlet weak var BrandsCV: UICollectionView!{
        didSet{
            BrandsCV.dataSource = self
            BrandsCV.delegate = self
            BrandsCV.layer.cornerRadius = 20
            BrandsCV.layer.borderWidth = 5
            BrandsCV.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dispatchgroup = DispatchGroup()
        
        Brandviewmodel = BrandViewModel()
        
        let nib = UINib(nibName: "BrandCVCell", bundle: nil)
        OfferCV.register(nib,forCellWithReuseIdentifier: "offerbrandcell")
        BrandsCV.register(nib, forCellWithReuseIdentifier: "offerbrandcell")
        
        Offerviewmodel = OfferViewModel()
        
        dispatchgroup.enter()
        Brandviewmodel?.getdata(url: "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01/smart_collections.json")
     //   arrayofimg
        
        Brandviewmodel?.bindResultOfBrandsToHomeViewController = { [self] () in
            self.BrandCollectionviewresponse = self.Brandviewmodel?.DataOfBrands
            dispatchgroup.leave()
        }
        
        dispatchgroup.enter()
        Offerviewmodel?.getoffer(url: "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01/price_rules/1380100899094/discount_codes.json")
            
        Offerviewmodel?.bindResultOfOffersToHomeViewController = { () in
            self.OfferCollectionviewresponse = self.Offerviewmodel?.DataOfOffers
            self.numberofdots = self.OfferCollectionviewresponse?.discount_codes.count
            dispatchgroup.leave()
        }
                
        dispatchgroup.notify(queue: .main)
        {
            self.arrayofimg = self.arrayofimg2
            self.BrandsCV.reloadData()
            self.OfferCV.reloadData()
                    
        }
        addBarButtonItems()
        startTimer()
        pagecontroller.numberOfPages = arrayofimg2?.count ?? 0
        }
    
    func showimg()
    {
        
    }
        
        func startTimer()
        {
            timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(movetonext), userInfo: nil, repeats: true)
        }
        
        @objc func movetonext()
        {
            if currentcellindex < (arrayofimg?.count ?? 0) - 1
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
            
            let searchobj = self.storyboard?.instantiateViewController(withIdentifier: "productsid") as! ProductsVC
            self.navigationController?.pushViewController(searchobj, animated: true)
        }
    }

extension HomeVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case OfferCV:
            return arrayofimg?.count ?? 0
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
            cell.offerbrandimg.kf.setImage(with: URL(string: arrayofimg?[indexPath.row] ?? ""),placeholder: UIImage(named: "loading.png"), options: [.keepCurrentImageWhileLoading], progressBlock: nil, completionHandler: nil)
            return cell
            
            case BrandsCV:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerbrandcell", for: indexPath) as! BrandCVCell
            cell.offerbrandimg.kf.setImage(with: URL(string: BrandCollectionviewresponse?.smart_collections[indexPath.row].image.src ?? ""),placeholder: UIImage(named: "loading.png"), options: [.keepCurrentImageWhileLoading], progressBlock: nil, completionHandler: nil)
                cell.layer.cornerRadius = 20
                cell.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
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
            case OfferCV:
               let pasteboard = UIPasteboard.general
            pasteboard.string = OfferCollectionviewresponse?.discount_codes[indexPath.row].code
            case BrandsCV:
                let productobj : ProductsVC = self.storyboard?.instantiateViewController(withIdentifier: "productsid") as! ProductsVC
            productobj.brandId = String(BrandCollectionviewresponse?.smart_collections[indexPath.row].id ?? 0)
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
