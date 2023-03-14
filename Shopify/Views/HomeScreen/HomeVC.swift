//
//  ViewController.swift
//  Shopify
//
//  Created by Adham Samer on 17/02/2023.
//

import Kingfisher
import UIKit

class HomeVC: UIViewController {
    var Brandviewmodel: BrandViewModel?
    var BrandCollectionviewresponse: Brands?

    var Offerviewmodel: OfferViewModel?
    var OfferCollectionviewresponse: Discounts?

    var arrayofimg: [String] = []

    var timer: Timer?
    var currentcellindex = 0
    var numberofdots: Int?
    // var arrimg : []?

    var nsDefault = UserDefaults()
    @IBOutlet var pagecontroller: UIPageControl!
    @IBOutlet var OfferCV: UICollectionView! {
        didSet {
            OfferCV.delegate = self
            OfferCV.dataSource = self
            OfferCV.layer.cornerRadius = 20
            OfferCV.layer.borderWidth = 2
            OfferCV.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
            //OfferCV.layer.shadowColor = UIColor(named: "gray")?.cgColor
            OfferCV.layer.shadowColor = UIColor(named: "AccentColor")?.cgColor
            OfferCV.layer.shadowOffset = CGSize(width: 0, height: 0)
            OfferCV.layer.shadowRadius = 3
            OfferCV.layer.shadowOpacity = 1
            OfferCV.layer.masksToBounds = false
            
        }
    }

    @IBOutlet var BrandsCV: UICollectionView! {
        didSet {
            BrandsCV.dataSource = self
            BrandsCV.delegate = self
            //BrandsCV.layer.cornerRadius = 20
           // BrandsCV.layer.borderWidth = 5
           // BrandsCV.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let dispatchgroup = DispatchGroup()

        Brandviewmodel = BrandViewModel()

        let nib = UINib(nibName: "BrandCVCell", bundle: nil)
        OfferCV.register(nib, forCellWithReuseIdentifier: "offerbrandcell")
        BrandsCV.register(nib, forCellWithReuseIdentifier: "offerbrandcell")

        Offerviewmodel = OfferViewModel()

        dispatchgroup.enter()
        Brandviewmodel?.getdata(target: .brand)

        Brandviewmodel?.bindResultOfBrandsToHomeViewController = { [self] () in
            self.BrandCollectionviewresponse = self.Brandviewmodel?.DataOfBrands
            dispatchgroup.leave()
        }

        dispatchgroup.enter()
        Offerviewmodel?.getoffer(target: .discounts)

        Offerviewmodel?.bindResultOfOffersToHomeViewController = { () in
            self.OfferCollectionviewresponse = self.Offerviewmodel?.DataOfOffers
            self.numberofdots = self.OfferCollectionviewresponse?.discount_codes.count
            dispatchgroup.leave()
        }
        nsDefault.setValue("EGP", forKey: "CashType")
        dispatchgroup.notify(queue: .main) {
            //  self.arrayofimg = arrayofimg2
            self.pagecontroller.numberOfPages = self.OfferCollectionviewresponse?.discount_codes.count ?? 0
            for img in 0 ... (self.OfferCollectionviewresponse?.discount_codes.count ?? 0) - 1 {
                self.arrayofimg.append(arrayofimg2?[img] ?? "")
            }
            self.BrandsCV.reloadData()
            self.OfferCV.reloadData()
        }
        addBarButtonItems()
        startTimer()
    }

    // MARK: PageControl

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(movetonext), userInfo: nil, repeats: true)
    }

    @objc func movetonext() {
        if currentcellindex < (arrayofimg.count) - 1 {
            currentcellindex += 1
        } else {
            currentcellindex = 0
        }
        OfferCV.scrollToItem(at: IndexPath(item: currentcellindex, section: 0), at: .centeredHorizontally, animated: true)
        pagecontroller.currentPage = currentcellindex
    }

    func addBarButtonItems() {
        let fav = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(navfav))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "white")

        let cart = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(navcart))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "CoffeeColor")

        navigationItem.rightBarButtonItems = [fav, cart]

        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(navsearch))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "CoffeeColor")
        navigationItem.leftBarButtonItem = search
    }

    // MARK: Navigation Functions

    @objc func navfav() {
        if !nsDefault.bool(forKey: "isLogged"){
            showAlert(title: "Sorry", msg: "Please Sign in or Register to get full access") { _ in
                self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
        }else{
            let FavouriteStoryBoardd = UIStoryboard(name: "ProfileSB", bundle: nil)
            let favobj = FavouriteStoryBoardd.instantiateViewController(withIdentifier: "wishlistseemoreVC") as! WishListSeeMoreVC
            navigationController?.pushViewController(favobj, animated: true)
        }
        
    }

    @objc func navcart() {
        if (nsDefault.value(forKey: "isLogged") as? Bool) ?? false {
            let CartStoryBoard = UIStoryboard(name: "OthersSB", bundle: nil)
            let cartobj =
                CartStoryBoard.instantiateViewController(withIdentifier: "cartid") as! CartVC
            navigationController?.pushViewController(cartobj, animated: true)

        } else {
            showAlert(title: "Sorry", msg: "Please Sign in or Register to get full access") { _ in
                self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
        }
    }

    @objc func navsearch() {
        let searchobj = storyboard?.instantiateViewController(withIdentifier: "productsid") as! ProductsVC
        navigationController?.pushViewController(searchobj, animated: true)
    }
}

// MARK: CollectionView

extension HomeVC: UICollectionViewDataSource {
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
            cell.offerbrandimg.kf.setImage(with: URL(string: arrayofimg[indexPath.row]), placeholder: UIImage(named: "loading.png"), options: [.keepCurrentImageWhileLoading], progressBlock: nil, completionHandler: nil)
            return cell

        case BrandsCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerbrandcell", for: indexPath) as! BrandCVCell
            cell.offerbrandimg.kf.setImage(with: URL(string: BrandCollectionviewresponse?.smart_collections[indexPath.row].image.src ?? ""), placeholder: UIImage(named: "loading.png"), options: [.keepCurrentImageWhileLoading], progressBlock: nil, completionHandler: nil)
            cell.layer.cornerRadius = 20
            cell.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
            cell.layer.borderWidth = 2
            cell.layer.shadowColor = UIColor(named: "AccentColor")?.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 3
            cell.layer.shadowOpacity = 1
            cell.layer.masksToBounds = false

            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case OfferCV:
            let pasteboard = UIPasteboard.general
            pasteboard.string = OfferCollectionviewresponse?.discount_codes[indexPath.row].code
            showToastMessage(message: "Code Copied", color: .black)
        case BrandsCV:
            let productobj: ProductsVC = storyboard?.instantiateViewController(withIdentifier: "productsid") as! ProductsVC
            productobj.brandId = String(BrandCollectionviewresponse?.smart_collections[indexPath.row].id ?? 0)
            navigationController?.pushViewController(productobj, animated: true)
        default:
            break
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case OfferCV:
            return CGSize(width: OfferCV.layer.frame.size.width - 16, height: OfferCV.layer.frame.size.height - 20)
        case BrandsCV:
            return CGSize(width: BrandsCV.layer.frame.size.width / 2 - 16, height: BrandsCV.layer.frame.size.height / 2 - 10)
        default:
            return CGSize(width: (UIScreen.main.bounds.size.width / 2) - 50, height: (UIScreen.main.bounds.size.height / 6) - 10)
        }
    }
}

// MARK: Rendering

extension HomeVC {
    func showToastMessage(message: String, color: UIColor) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.bounds.size.width / 2 - 90, y: self.view.bounds.size.height - 130, width: self.view.bounds.size.width / 2 - 20, height: 30))

        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = color
        toastLabel.textColor = .white
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        view.addSubview(toastLabel)

        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }

    func showAlert(title: String, msg: String, handler: @escaping (UIAlertAction?) -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in handler(action) }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            () }))
        present(alert, animated: true, completion: nil)
    }
}
