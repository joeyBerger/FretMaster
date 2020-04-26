import UIKit

let apiKey = "k9R4gpOPjBryyZP95PslV1W08oWP2W8B7Va8GxgG3bA"

class Unsplash {
    func unsplashSearch(for searchCriteria: String, completion: @escaping (URLs?, Error?) -> Void) {
        print("searchCriteria \(searchCriteria)")
        if let url = URL.with(string: "search/photos?query=\(searchCriteria)&per_page=100") {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                if let data = data {
                    do {
                        let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject]
                        let photosContainer = resultsDictionary!["results"] as! [AnyObject]
                        let finalURLs = photosContainer.randomElement()!["urls"] as! [String: AnyObject]
                        let newImage = URLs(raw: finalURLs["raw"] as! String,
                                            full: finalURLs["full"] as! String,
                                            regular: finalURLs["regular"] as! String,
                                            small: finalURLs["small"] as! String,
                                            thumb: finalURLs["thumb"] as! String)
                        DispatchQueue.main.async {
                            completion(newImage, nil)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                }
            }.resume()
        }
    }

    func unsplashImageDownload(for imageURL: String, completion: @escaping (UIImage?, String?) -> Void) {
        let url = URL(string: imageURL)

        let imageData = try? Data(contentsOf: url!)
        if let image = UIImage(data: imageData!) {
            DispatchQueue.main.async {
                completion(image, nil)
            }
        } else {
            completion(nil, "Error Downloading Image")
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

struct URLs: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
