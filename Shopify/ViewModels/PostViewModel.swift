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
class AddressesFunctions {
    func postCode(target: EndPoints, parameters: [String : Any])
        {
            NetworkServices.postData(url: target.path, parameters: parameters,err:{_ in })
        }
    func putCode(target: EndPoints, parameters: [String : Any])
        {
            NetworkServices.putMethod(url: target.path, parameters: parameters)
        }
    func deleteCode(target: EndPoints)
    {
        NetworkServices.delete(url: target.path)
    }
}
