//
//  APIClient.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/30.
//

import Foundation

protocol APIClientInput {
    func getUserData(parameter: GithubAPIParameter,
                     completion: ((Result<GithubAPIResults, GithubAPIError>) -> Void)?)
}

final class APIClient {
    static let shared = APIClient()
    private init() {}
}

extension APIClient: APIClientInput {
    func getUserData(
        parameter: GithubAPIParameter,
        completion: ((Result<GithubAPIResults, GithubAPIError>) -> Void)? = nil
    ) {
        guard
            parameter.validation
        else {
            completion?(.failure(.invalidParameter))
            return
        }
        let request = URLRequest(url: URL(string: "https://api.github.com/search/repositories?\(parameter.queryParameter)")!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion?(.failure(.network))
                return
            }
            
            guard
                let response = response as? HTTPURLResponse
            else {
                completion?(.failure(.noResponse))
                return
            }
            guard
                case 200 ..< 300 = response.statusCode
            else {
                completion?(.failure(.server))
                return
            }
            
            guard
                let data = data
            else {
                completion?(.failure(.noData))
                return
            }
            do {
                let results = try JSONDecoder().decode(GithubAPIResults.self, from: data)
                completion?(.success(results))
            } catch {
                completion?(.failure(.decode))
            }
        }
        
        task.resume()
        
    }
}
