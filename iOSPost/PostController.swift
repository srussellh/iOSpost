//
//  PostController.swift
//  iOSPost
//
//  Created by Bobba Kadush on 5/13/19.
//  Copyright © 2019 Bobba Kadush. All rights reserved.
//

import Foundation


class PostController {
    
    let baseURL = "http://devmtn-posts.firebaseio.com/posts"
    
    static let shared = PostController()
    
    var posts: [Post] = []
    
    func fetchPosts(reset: Bool = true, completion: @escaping() -> Void){
        
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.timestamp ?? Date().timeIntervalSince1970
        
        guard let url = URL(string: baseURL) else {return}
        
        let urlParameters = [ "orderBy": "\"timestamp\"", "endAt": "\(queryEndInterval)", "limitToLast": "15", ]
        let queryItems = urlParameters.compactMap( { URLQueryItem(name: $0.key, value: $0.value) } )
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        guard let newURL = urlComponents?.url else {return}
        
        let getterEndpoint = url.appendingPathExtension("json")
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: getterEndpoint) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion()
                return
            }
            guard let data = data else {return}
            let decoder = JSONDecoder()
            do{
                
                let postDictionary = try decoder.decode([String:Post].self, from: data)
                var posts = postDictionary.compactMap({$0.value})
                posts.sort(by: {$0.timestamp>$1.timestamp})
                self.posts = posts
                completion()
            } catch {
                print(error.localizedDescription)
                completion()
                return
            }
        }
        dataTask.resume()
    }
    
    func addNewPostWith(username: String, Text: String, completion: @escaping() -> Void){
        let post = Post(text: Text, username: username)
        var postData: Data?
        do{
            let encoder = JSONEncoder()
            postData = try encoder.encode(post)
            
        }catch{
            print("problems encoding data: \(error.localizedDescription)")
        }
        guard let url = URL(string: baseURL) else {return}
        let postEndpoint = url.appendingPathExtension("json")
        var request = URLRequest(url: postEndpoint)
        request.httpBody = postData
        request.httpMethod = "POST"
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error with uploading: \(error)")
                completion()
                return
            }
            guard let data = data else {return}
            self.fetchPosts {
                completion()
            }
            
        }
        dataTask.resume()
    }
}
