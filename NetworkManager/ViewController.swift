//
//  ViewController.swift
//  NetworkManager
//
//  Created by SERGEY VOROBEV on 14.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = NetworkManager()

        manager.httpGetRequest(url: "https://jsonplaceholder.typicode.com/posts") { (response: NetworkManagerResponse<Post>) in
            switch response {
            case .success(let posts):
                print(posts.count)
            case .failure(let error, let message):
                print(message)
            default:
                break
            }
        }
    }
    
    
}

