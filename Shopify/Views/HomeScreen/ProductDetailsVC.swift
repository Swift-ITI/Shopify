//
//  ProductDetailsVC.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Cosmos
import Kingfisher
import UIKit

class ProductDetailsVC: UIViewController {
    
    @IBOutlet weak var availableQuantity: UILabel!
    @IBOutlet var productname: UILabel!
    @IBOutlet var productprice: UILabel!
    @IBOutlet var pulldowncolor: UIButton!
    @IBOutlet var pulldownsize: UIButton!
    @IBOutlet var pagecontrol: UIPageControl!
    @IBOutlet var ItemCV: UICollectionView! {
        didSet {
            ItemCV.delegate = self
            ItemCV.dataSource = self
            ItemCV.layer.borderWidth = 2
            ItemCV.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
            ItemCV.layer.masksToBounds = true
            ItemCV.layer.cornerRadius = 15
            ItemCV.layer.shadowColor = UIColor(named: "AccentColor")?.cgColor
            ItemCV.layer.shadowOffset = CGSize(width: 0, height: 0)
            ItemCV.layer.shadowRadius = 3
            ItemCV.layer.shadowOpacity = 1
            ItemCV.layer.masksToBounds = false

            let nib = UINib(nibName: "BrandCVCell", bundle: nil)
            ItemCV.register(nib, forCellWithReuseIdentifier: "offerbrandcell")
        }
    }
    @IBOutlet var reviewTableView: UITableView! {
        didSet {
            reviewTableView.delegate = self
            reviewTableView.dataSource = self
            reviewTableView.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
            reviewTableView.layer.borderWidth = 1.5
            reviewTableView.layer.cornerRadius = 20
            let nibT = UINib(nibName: "ReviewTVCell", bundle: nil)
            reviewTableView.register(nibT, forCellReuseIdentifier: "reviewTVCell")
        }
    }
    @IBOutlet var productdescription: UITextView!
    @IBOutlet var favbtn: UIButton!
    
    private var flag: Bool = false
    var currentcellindex = 0
    var timer: Timer?
    var isDuplicated : Int = 2
    
    var coredatavm : FavCoreDataViewModel?
    var favcoredataobj : FavCoreDataManager?
    
    var detailedProduct: Product?

    var cartVM: DraftOrderViewModel?
    var draftOrder: SingleDraftOrder?
    
    var nsDefault = UserDefaults()
    
    var lineItems: [[String: Any]] = []
    var lineItem: [String: Any] = [:]
    
    var coreDataVM : CoreDataViewModel?
    var coreData : CoreDataManager?
    
    var reviewName = ["Robert J.", "Evelyn Taal", "Gong Yoo", "Park Seo joa", "Sila M."]
    var reviewRate = ["3", "2", "5", "3", "4"]
    var reviewComment = ["Bad quality", "Uncomfortable product" , "Comfortable, Highly recommended!", "Pretty, and not a bad quality for this price! " , "Really nice fit and very comfortable."]

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        
        productname.text = detailedProduct?.title
        productprice.text = "\(CurrencyExchanger.changeCurrency(cash: detailedProduct?.variants?[0].price ?? ""))\(nsDefault.value(forKey: "CashType") ?? "")"
        productdescription.text = detailedProduct?.body_html
        availableQuantity.text = "Available Quantity: \((detailedProduct?.variants?[0].inventory_quantity)?.formatted() ?? "")"
        pagecontrol.numberOfPages = detailedProduct?.images?.count ?? 0
        
        productfilter(sender: pulldownsize)
        productfilter(sender: pulldowncolor)

        coreDataVM = CoreDataViewModel()
        coreData = coreDataVM?.getInstance()
        
        cartVM = DraftOrderViewModel()
        getOrders()
        
        coredatavm = FavCoreDataViewModel()
        favcoredataobj = coredatavm?.getfavInstance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (favcoredataobj?.isFav(lineItemId: detailedProduct?.id ?? 0))! {
         
            favbtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            flag = true
            print("exist")
           
        } else {
         
            favbtn.setImage(UIImage(systemName: "heart"), for: .normal)
            flag = false
           print("Not")
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(movetonext), userInfo: nil, repeats: true)
    }

    @objc func movetonext() {
        if currentcellindex < (detailedProduct?.images?.count ?? 0) - 1 {
            currentcellindex += 1
        } else {
            currentcellindex = 0
        }
        ItemCV.scrollToItem(at: IndexPath(item: currentcellindex, section: 0), at: .centeredHorizontally, animated: true)
        pagecontrol.currentPage = currentcellindex
    }
    //MARK: Add to cart
    @IBAction func addtocart(_ sender: Any) {
        if !nsDefault.bool(forKey: "isLogged"){
            showAlert(title: "Sorry", msg: "Please Sign in or Register to get full access") { action in
                self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
        }else{
            getOrders()
            
            if coreData!.isInCart(lineItemId: detailedProduct?.id ?? 0){
                print("ddddddddddddddd")
                isDuplicated = 1
            }
            
            if nsDefault.value(forKey: "note") as? String == "first" {
                
                let params: [String: Any] = [
                    "draft_order": [
                        "email": nsDefault.value(forKey: "customerEmail") as? String ?? "",
                        "currency": "EGP",
                        "line_items": [
                            [
                                "variant_id": detailedProduct?.variants?[0].id ?? 0,
                                "product_id": detailedProduct?.id ?? 0,
                                "title": detailedProduct?.title ?? "",
                                "vendor": detailedProduct?.vendor ?? "",
                                "quantity": 1,
                                "price": detailedProduct?.variants?[0].price ?? ""
                            ],
                        ],
                    ],
                ]
                cartVM?.postNewDraftOrder(target: .alldraftOrders, params: params)
                
              //  getOrders()
                
                coreData?.SaveToCoreData(draftOrderId: (self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0),productId: detailedProduct?.id ?? 0, title: detailedProduct?.title ?? "", price: detailedProduct?.variants?[0].price ?? "", quantity: 1)

                cartVM?.bindErrorToCartVC = {
                    DispatchQueue.main.async {
                        switch self.cartVM?.error?.keys.formatted() {
                        case "draft_order":
                            
                            let draftOrderDict = self.cartVM?.error?["draft_order"] as? [String: Any]
                            self.nsDefault.set("created", forKey: "note")
                            self.nsDefault.set(draftOrderDict?["id"] as? Int, forKey: "draftOrderID")
                            print("draftOrderId=\(self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0)")
                            self.getOrders()
                            //self.showAlert(title: "SUCESS", msg: "successfully added to cart") {_ in }
                            self.showToastMessage(message: "Sucessfully added to cart", color: .white)
                     
                        case "error":
                            print("Error Found")
                        default:
                            print("Default")
                        }
                    }
                }
            } else {
                getOrders()
        
                switch isDuplicated {
                case 1:
                    print("don't save")
                    self.showAlert(title: "OH --ooh!", msg: "Already added to cart") {_ in }
                case 2:
                    self.lineItem = [
                        "variant_id": detailedProduct?.variants?[0].id ?? 0,
                        "product_id": detailedProduct?.id ?? 0,
                        "title": self.detailedProduct?.title ?? "",
                        "vendor": self.detailedProduct?.vendor ?? "",
                        "quantity": 1,
                        "price": self.detailedProduct?.variants?[0].price ?? "",
                        "sku" : self.detailedProduct?.image?.src ?? ""
                    ]
                    self.lineItems.append(self.lineItem)

                    let params = [
                        "draft_order": [
                            "line_items": self.lineItems,
                        ],
                    ]

                    self.cartVM?.editDraftOrder(target: .draftOrder(id: (self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0)), params: params)
                    coreData?.SaveToCoreData(draftOrderId: (self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0),productId: detailedProduct?.id ?? 0, title: detailedProduct?.title ?? "", price: detailedProduct?.variants?[0].price ?? "", quantity: 1)
                    self.showToastMessage(message: "Sucessfully added to cart", color: .black)
                    self.getOrders()
//                    self.showAlert(title: "SUCESS", msg: "successfully added to cart") {_ in
//                        self.getOrders()
//                    }
                  
                    //getOrders()

                default:
                    break
                }
            }
        }
        
    }
    
    

    //MARK: Add to favourites
    @IBAction func addtofavourite(_ sender: Any) {
        if !nsDefault.bool(forKey: "isLogged"){
            showAlert(title: "Sorry", msg: "Please Sign in or Register to get full access") { action in
                self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
        }else{
            if flag {
                favbtn.setImage(UIImage(systemName: "heart"), for: .normal)
                favcoredataobj?.DeleteFromFav(lineitemID: detailedProduct?.id ?? 0)
                flag = false
            } else {
                favbtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favcoredataobj?.SaveFavtoCoreData(draftOrderID: (self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0 ), productID: detailedProduct?.id ?? 0, title: detailedProduct?.title ?? "" , price: detailedProduct?.variants?[0].price ?? "", quantity: 1, img: detailedProduct?.image?.src ?? "")
                flag = true
            }
        }
        
    }

    //MARK: Various Functions
    func productfilter(sender: UIButton) {
        switch sender {
        case pulldowncolor:
            let c = { (_: UIAction) in }
            let colors = detailedProduct?.options?[1].values
            var colorsAction: [UIAction] = []
            for color in colors! {
                colorsAction.append(UIAction(title: color, handler: c))
            }
            pulldowncolor.menu = UIMenu(title: "", children: colorsAction)
            pulldowncolor.showsMenuAsPrimaryAction = true

        case pulldownsize:
            let c = { (_: UIAction) in
            }
            let sizes = detailedProduct?.options?[0].values
            var sizesAction: [UIAction] = []
            for size in sizes! {
                sizesAction.append(UIAction(title: size, handler: c))
            }
            pulldownsize.menu = UIMenu(title: "", children: sizesAction)
            pulldownsize.showsMenuAsPrimaryAction = true

        default:
            print("no")
        }
    }
    
    func getOrders(){
        print("NS: \(String(describing: nsDefault.value(forKey: "draftOrderID")))")
        
        cartVM?.getDraftOrders(target: .draftOrder(id: (nsDefault.value(forKey: "draftOrderID") as? Int ?? 0)))
        cartVM?.bindDraftOrderToCartVC = {
            DispatchQueue.main.async {
                self.draftOrder = self.cartVM?.draftOrderResults
                //self.lineItems = self.cartVM?.draftOrderResults?.draft_orders?.first?.line_items as! [[String : Any]]
                for lineItem in self.draftOrder?.draft_order?.line_items ?? [] {
                    let tmp : [String : Any] = [
                        "variant_id": lineItem.variant_id ?? 0,
                        "product_id": lineItem.product_id ?? 0,
                        "title": lineItem.title ?? "",
                        "vendor": lineItem.vendor ?? "",
                        "quantity": 1,
                        "price": lineItem.price ?? "",
                    ]
                    self.lineItems.append(tmp)
                }
                print("ccccccccccccc\(self.lineItems)")
            }
        }
    }
}

// MARK: - Collection View Extension

extension ProductDetailsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailedProduct?.images?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerbrandcell", for: indexPath) as! BrandCVCell

        cell.offerbrandimg.kf.setImage(with: URL(string: detailedProduct?.images?[indexPath.row].src ?? ""))
        return cell
    }
}

extension ProductDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ItemCV.layer.frame.size.width - 5, height: ItemCV.layer.frame.size.height - 5)
    }
}

// MARK: - Table View Extension

extension ProductDetailsVC: UITableViewDelegate {
}

extension ProductDetailsVC: UITableViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTVCell", for: indexPath) as! ReviewTVCell
        cell.nameTxt.text = reviewName[indexPath.row]
        cell.ratingText.text = "\(reviewRate[indexPath.row]) ⭐️"
        cell.reviewText.text = reviewComment[indexPath.row]

        return cell
    }
}

//MARK: Rendering
extension ProductDetailsVC {
    func showAlert(title: String, msg: String,handler:@escaping (UIAlertAction?)->Void) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in handler(action)}))
        present(alert, animated: true, completion: nil)
        
    }
}
extension ProductDetailsVC
{
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
}
