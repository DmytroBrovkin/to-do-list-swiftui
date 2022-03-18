//
//  APIHelper.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//
import Foundation
import Combine

class APIHelper {
    private let session: URLSession
    private let baseUrl: URL
    private var authKey: String?
    
    init(baseUrl: URL = URL(string: "https://education.octodev.net/api/v1")!, authKey: String? = nil) {
        self.baseUrl = baseUrl
        self.authKey = authKey
        session = .default        
    }
    
    // MARK: - Success block is Array
    func get<T>(path: String,
                params: [String: String]?,
                headerParams: [String: String]? = nil) -> AnyPublisher<T, NSError> where T: Decodable {
        let urlRequest = self.createGetRequest(path: path, params: params, headerParams: headerParams)
        return dataTask(with: urlRequest)
    }
    
    func post<T, V>(path: String, params: V?) -> AnyPublisher<T, NSError> where T: Decodable, V: Sequence {
        let urlRequest = self.createPostRequest(path: path, params: params)
        return dataTask(with: urlRequest)
    }
    
    func put<T>(path: String, params: [String: String]?) -> AnyPublisher<T, NSError> where T: Decodable {
        var urlRequest = self.createGetRequest(path: path, params: params, headerParams: nil)
        urlRequest.httpMethod = "PUT"
        return dataTask(with: urlRequest)
    }

    func delete<T>(path: String, params: [String: String]?) -> AnyPublisher<T, NSError> where T: Decodable {
        var urlRequest = self.createGetRequest(path: path, params: params, headerParams: nil)
        urlRequest.httpMethod = "DELETE"
        return dataTask(with: urlRequest)
    }

    private func dataTask<T>(with urlRequest: URLRequest) -> AnyPublisher<T, NSError> where T: Decodable  {
        print(urlRequest)
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else { throw NSError.badServerResponse }
                guard httpResponse.statusCode == 200 else {
                    let userInfo = element.data.dict ?? [:]
                    throw NSError(domain: "", code: httpResponse.statusCode, userInfo: userInfo)
                }
                print(element.data.dict)
                print(element.data.array)
                return element.data
              }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                error as NSError
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helper funcs
    private func createGetRequest(path: String, params: [String: String]?, headerParams: [String: String]?) -> URLRequest {
        let urlComponents = self.urlComponents(with: path)
        urlComponents.queryItems = params?.map { (key, value) -> URLQueryItem in URLQueryItem(name: key, value: value) }
        
        var urlRequest = self.urlRequest(with: urlComponents.url!)
        headerParams?.forEach { header in urlRequest.setValue(header.value, forHTTPHeaderField: header.key) }
        
        return urlRequest
    }
    
    private func createPostRequest<T: Sequence>(path: String, params: T?) -> URLRequest {
        let urlComponents = self.urlComponents(with: path)
        var urlRequest = self.urlRequest(with: urlComponents.url!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = params?.data
        urlRequest.httpMethod = "POST"
        
        return urlRequest
    }
    
    private func urlRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        if let authKey = self.authKey {
            request.setValue("Bearer " + authKey, forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    private func urlComponents(with path: String) -> NSURLComponents {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = baseUrl.scheme
        urlComponents.host = baseUrl.host
        urlComponents.path = baseUrl.path + "/" + path
        
        return urlComponents
    }
}
