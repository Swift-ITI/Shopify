//
//  PostViewModel.swift
//  Shopify
//
//  Created by Adham Samer on 03/03/2023.
//

import Foundation

class PostUserViewModel {
    var bindErrorToVC:(()->()) = {}
    var error:[String:Any]? {
        didSet{
            bindErrorToVC()
        }
    }
    func postCustomer(target: EndPoints,parameters:[String:Any]){
        NetworkServices.postData(url: target.path, parameters: parameters, err: {error in
            self.error = error
        } )
    }

}

class PostAddressViewModel {
    var bindErrorsToVC:(()->()) = {}
    var errors:[String:Any]? {
        didSet{
            bindErrorsToVC()
        }
    }
    func postAddress(target: EndPoints, parameters: [String : Any])
        {
            NetworkServices.postData(url: target.path, parameters: parameters,err:{errors in self.errors = errors })
        }
    func editAddress(target: EndPoints, parameters: [String : Any])
        {
            NetworkServices.putMethod(url: target.path, parameters: parameters,err:{errors in self.errors = errors })
        }
    func deleteAddress(target: EndPoints)
    {
        NetworkServices.delete(url: target.path)
    }
}

class PostOrderViewModel{
    var bindResultToOrders: (() -> Void) = {}
    var errors:[String:Any]?{
        didSet{
            bindResultToOrders()
        }
    }
    func postOrder(target: EndPoints, parameters: [String : Any])
    {
        NetworkServices.postData(url: target.path, parameters: parameters, err: {errors in self.errors = errors})
    }
}

class PutCustomerViewModel
{
    var bindResultOfCustomerToOrderDetailsViewController: (() -> Void) = {}
    
    var CustomerData : [String : Any]?
    {
        didSet
        {
            bindResultOfCustomerToOrderDetailsViewController()
        }
    }
    
    func putToCustomer(target : EndPoints, parameters:[String : Any])
    {
        NetworkServices.putMethod(url: target.path, parameters: parameters , err:{ result in
            self.CustomerData = result
        })
    }
}

class DeleteDraftOrder
{
    var bindResultToDraftOrders: (() -> Void) = {}
    var errors:[String:Any]?{
        didSet{
            bindResultToDraftOrders()
        }
    }
    
    func deleteDraftOrder(target : EndPoints)
    {
        NetworkServices.delete(url: target.path)
    }
}
