//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Joey Berger on 4/18/20.
//  Copyright © 2020 Joey Berger. All rights reserved.
//

import UIKit

let apiKey = "adff54e787e668b58ca1b231a21629ac"

class Flickr {
    enum Error: Swift.Error {
        case generic
    }
    
    func searchFlickrForArray(for searchCriteria: String, complettion: @escaping ([[Any]]?, Error?) -> Void) {
        guard let searchURL = flickrSearchURL(for: searchCriteria) else {
            complettion(nil, Error.generic)
            return
        }
        
        let searchRequest = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: searchRequest) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    complettion(nil, Error.generic)
                }
                return
            }
            
            guard
                let _ = response as? HTTPURLResponse,
                let data = data
                else {
                    DispatchQueue.main.async {
                        complettion(nil, Error.generic)
                    }
                    return
            }
            
            do {
                guard
                    let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject]
                    else {
                        DispatchQueue.main.async {
                            complettion(nil, Error.generic)
                        }
                        return
                }
                
                guard
                    let photosContainer = resultsDictionary["photos"] as? [String: AnyObject],
                    let photosReceived = photosContainer["photo"] as? [[String: AnyObject]]
                    else {
                        DispatchQueue.main.async {
                            complettion(nil, Error.generic)
                        }
                        return
                }
                
                let array: [[Any]] = photosReceived.compactMap { photoObject in
                    let photoID = photoObject["id"] as? String
                    let farm = photoObject["farm"] as? Int
                    let server = photoObject["server"] as? String
                    let secret = photoObject["secret"] as? String
                    
                    let returnArr: [Any] = [photoID!,farm!,server!,secret!]
                    return returnArr
                }
                
                complettion(array, nil)
                
            } catch {
                complettion(nil, Error.generic)
                return
            }
        }.resume()
    }
    
    func downloadAndReturnImage(imageInfo: [Any], completion: @escaping (UIImage) -> Void) {
        let flickrPhoto = FlickrPhoto(photoID: imageInfo[0] as! String, farm: imageInfo[1] as! Int, server: imageInfo[2] as! String, secret: imageInfo[3] as! String)
        
        guard
            let url = flickrPhoto.flickrImageURL(),
            let imageData = try? Data(contentsOf: url as URL)
            else {
                return
        }
        
        if let image = UIImage(data: imageData) {
            flickrPhoto.thumbnail = image
            DispatchQueue.main.async {
                completion(flickrPhoto.thumbnail!)  //doesn't make sense to have thumbnail
            }
        } else {
            return
        }
    }
    
    private func flickrSearchURL(for searchCriteria: String) -> URL? {
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&per_page=1&tags=\(searchCriteria)&page=\(2)&format=json&nojsoncallback=1"
        return URL(string:URLString)
    }
    
    
    //  func searchFlickrForArray(for searchCriteria: String, complettion: @escaping ([[Any]]?, Error?) -> Void) {
    func unsplashImageDownload(for imageURL: String, completion: @escaping (UIImage) -> Void) {
        //    let url = URL(string:"https://images.unsplash.com/photo-1585758888376-4a04c200841e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjEyOTQyMX0")
        
        let url = URL(string:imageURL)
        
        let imageData = try? Data(contentsOf: url!)
        if let image = UIImage(data: imageData!) {
            print("able to get image")
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func unsplashTry(for searchCriteria: String, completion: @escaping (URLs) -> Void) {
//        if let url = URL.with(string: "search/photos?page=1&query=\(searchCriteria)&per_page=100") {
        if let url = URL.with(string: "search/photos?query=\(searchCriteria)&per_page=100") {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("Client-ID k9R4gpOPjBryyZP95PslV1W08oWP2W8B7Va8GxgG3bA", forHTTPHeaderField: "Authorization")
            
            // ... URLSession
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    do {
                        let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject]
                        let photosContainer = resultsDictionary!["results"] as! Array<AnyObject>
                        let finalURLs = photosContainer.randomElement()!["urls"] as! [String: AnyObject]
                        let newImage = URLs(raw: finalURLs["raw"] as! String,
                                            full: finalURLs["full"] as! String,
                                            regular: finalURLs["regular"] as! String,
                                            small: finalURLs["small"] as! String,
                                            thumb: finalURLs["thumb"] as! String)
                        DispatchQueue.main.async {
                            completion(newImage)
                        }
                    } catch let error {
                        print("error 1 \(error)")
                    }
                    do {
                       let images = try JSONDecoder().decode([Image].self, from: data)
                        print(images.count) // get an array of image object
                        completion(images.randomElement()!.urls!)
                    } catch let error {
                       print("error 2 \(error)")
                    }
                }
            }.resume()
        }
    }
}

extension URL {
    private static var baseUrl: String {
        return "https://api.unsplash.com/"
    }
    
    static func with(string: String) -> URL? {
        return URL(string: "\(baseUrl)\(string)")
    }
}

struct CurrentUserLocation: Decodable {
    let id: Int
    let title: String
    // ...
}

struct Image: Decodable {
    let id: String?
    let width: Int?
    let height: Int?
    let color: String?
    let urls: URLs?
    let current_user_collections: [CurrentUserLocation]?
    let keyNotExist: String?
}

struct URLs: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct returnStruct {
    let raw: String
}
