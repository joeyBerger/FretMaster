//
//  UserAPI.swift
//  Guitar Mult
//
//  Created by Joey Berger on 10/30/20.
//

import Foundation

class UserAPI {
    
//    postInitialData
    
    
    static func postAPIRequest(_ url : String, _ parameters : [String: Any]) {
        //create the url with URL
        let url = URL(string: "https://guitar-mult-backend.herokuapp.com/"+url)! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    static func getAPIRequest(_ url : String, _ parameters : [String: Any]) {
        //create the url with URL
        let url = URL(string: "https://guitar-mult-backend.herokuapp.com/"+url)! //change the url
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            return
          }

            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        if json["updateLevels"] != nil {
                            if json["updateLevels"] as! Bool == true {
                                for (key,val) in json {
                                    if key != "updateLevels" {
                                        userLevelData.updateValueOnAPIRequest(key, val as! String)
                                    }
                                }
                            }
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
    

}

