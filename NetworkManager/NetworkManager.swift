import Foundation

enum NetworkManagerError {
    case wrongUrl
    case wrongResponse
    case httpError
    case dataError
    case jsonError
}

enum NetworkManagerResponse<T: Codable> {
    case success(data: [T])
    case failure(error: NetworkManagerError, message: String)
}

class NetworkManager {
    lazy private var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type":"application/json; charset=UTF-8"]
        config.waitsForConnectivity = false
        
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()
    
    func httpPostRequest<T: Codable>(url: String, completionHandler: @escaping (NetworkManagerResponse<T>) -> Void) {
        guard let urlPath = URL(string: url) else {
            completionHandler(.failure(error: .wrongUrl, message: "Wrong url \(url) passed"))
            return
        }
        
        var urlRequest = URLRequest(url: urlPath)
        
        urlRequest.httpMethod = "POST"
    }
        
    func httpGetRequest<T: Codable>(url: String, completionHandler: @escaping (NetworkManagerResponse<T>) -> Void) {
        guard let urlPath = URL(string: url) else {
            completionHandler(.failure(error: .wrongUrl, message: "Wrong url \(url) passed"))
            return
        }
        
        let urlRequest = URLRequest(url: urlPath)
        
        let task = defaultSession.dataTask(with: urlRequest) { data, response, error in
     
            guard error == nil else {
                completionHandler(.failure(error: .httpError, message: "General HTTP error: \(error!.localizedDescription)"))
                
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse, (200..<300).contains(urlResponse.statusCode) else {
                completionHandler(.failure(error: .wrongResponse, message: "Wrong HTTP response"))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(error: .dataError, message: "Wrong HTTP response"))
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode([T].self, from: data)
                completionHandler(.success(data: jsonData))
            } catch (let error) {
                completionHandler(.failure(error: .jsonError, message: "Json parse error: \(error.localizedDescription)"))
            }
        }
        
        task.resume()
    }
}
