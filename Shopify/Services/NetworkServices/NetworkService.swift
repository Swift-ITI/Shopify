//
//  NetworkService.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Alamofire
import Foundation

protocol FETCH_DATA {
    static func fetch<T: Decodable>(url: String?, compiletionHandler: @escaping (T?) -> Void)
}

protocol POST_DATA {
    static func postData(url: String?, parameters: [String: Any], err: @escaping ([String: Any]?) -> Void)
}

protocol DELETE_DATA {
    static func delete(url: String)
}

protocol PUT_DATA {
    static func putMethod(url: String, parameters: [String: Any],err: @escaping ([String: Any]?) -> Void)
}


class NetworkServices: FETCH_DATA {
    static func fetch<T>(url: String?, compiletionHandler: @escaping (T?) -> Void) where T: Decodable {
        let request = AF.request(url ?? "")

        request.responseDecodable(of: T.self) { response in
            guard let resultOfAPI = response.value else {
                compiletionHandler(nil)
                return
            }
            compiletionHandler(resultOfAPI)

        }
    }
}

extension NetworkServices: POST_DATA {
    static func postData(url: String?, parameters: [String: Any], err: @escaping ([String: Any]?) -> Void) {
        guard let url = URL(string: url ?? "") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        print(parameters)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            // err(error)
        }

        // HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        session.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                // err(error)
                return
            }

            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

                print("POST METHOD :\(response)")
                err(response as? [String: Any])
            } catch {
                print("hii\(error)")
                // err(error)
            }

        }.resume()
    }
}

extension NetworkServices: DELETE_DATA {
    static func delete(url: String) {
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

extension NetworkServices: PUT_DATA {
    static func putMethod(url: String, parameters: [String: Any],err: @escaping ([String: Any]?) -> Void) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false

        print(parameters)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        // HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        session.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

                print("PUT METHOD :\(response)")
                err(response as? [String: Any])
            } catch {
                print(error)
            }
        }.resume()
    }
}
