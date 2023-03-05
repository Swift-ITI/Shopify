//
//  NetworkService.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Foundation
import Alamofire

protocol APIservices
{
    static func fetch <T : Decodable>(url:String?,compiletionHandler : @escaping (T?)->Void)
}

class NetworkServices : APIservices
{
    static func fetch<T>(url: String?, compiletionHandler: @escaping (T?) -> Void) where T : Decodable {
        let request = AF.request(url ?? "")
        
        request.responseDecodable(of:T.self) { (response) in
            guard let resultOfAPI = response.value else {
                
                compiletionHandler(nil)
                return }
            
            compiletionHandler(resultOfAPI)
        }
    }
}

extension NetworkServices
{
     static func delete(url: String)
     {
         var headers = HTTPHeaders()
         headers.add(name: "Content-Type", value: "application/json")
         headers.add(name: "Accept", value: "application/json")

         AF.request(url, method: .delete, headers: headers).response { response in
             switch response.result {
             case .success:
                 print("Deleted")
             case .failure:
                 print("Failed to delete")
             }
         }
     }
 }
