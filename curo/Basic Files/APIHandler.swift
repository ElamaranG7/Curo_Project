//
//  APIHandler.swift
//  curo
//
//  Created by SAIL on 14/03/24.
//

import Foundation
import UIKit


class APIHandler {
   
    static var shared: APIHandler = APIHandler()
    init() {}
    
    
    
    
func getAPIValues<T:Codable>(type: T.Type, apiUrl: String, method: String, onCompletion: @escaping (Result<T, Error>) -> Void) {
                print("apiUrl -----> \(apiUrl)")
        guard let url = URL(string: apiUrl) else {
                    let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
                    onCompletion(.failure(error))
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        onCompletion(.failure(error))
                        return
                    }
                    
                    guard let data = data else {
                        let error = NSError(domain: "No data received", code: 1, userInfo: nil)
                        onCompletion(.failure(error))
                        print("error ?????? \(error)")
                        return
                    }
                    
                    do {
                        let decodedData = try JSONDecoder().decode(type, from: data)
                        onCompletion(.success(decodedData))
                        print("decodedData >>>>> \(decodedData)")
                    } catch {
                        onCompletion(.failure(error))
                    }
                }
                
                task.resume()
            }
    
func postAPIValues<T: Codable>(type: T.Type,apiUrl: String,method: String,formData: [String: Any],onCompletion: @escaping (Result<T, Error>) -> Void) {
    
        guard let url = URL(string: apiUrl) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            onCompletion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var formDataString = ""
        for (key, value) in formData {
            formDataString += "\(key)=\(value)&"
        }
        formDataString = String(formDataString.dropLast())
        request.httpBody = formDataString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
        print("apiUrl -----> \(apiUrl)")
        print("formData -----> \(formData)")
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onCompletion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data received", code: 1, userInfo: nil)
                onCompletion(.failure(error))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                onCompletion(.success(decodedData))
                print("decodedData : \(decodedData)")
            } catch {
                onCompletion(.failure(error))
            }
        }
        
        task.resume()
}
}
