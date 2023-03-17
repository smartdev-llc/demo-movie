//
//  APIService.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

public enum APIError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

public protocol APIErrorLogger {
    func log(error: Error)
}

public protocol APIErrorResolver {
    func resolve(error: NetworkError) -> Error
}

public protocol APIService {
    typealias CompletionHandler<T> = (Result<T, APIError>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                       completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T
    @discardableResult
    func request<E: ResponseRequestable>(with endpoint: E,
                                         completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E.Response == Void
}


public class ImplNetworkSessionManager: NetworkSessionManager {
    public init() {}
    public func request(_ request: URLRequest,
                        completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}


public final class ImplNetworkErrorLogger: NetworkErrorLogger {
    public init() { }

    public func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            print("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            print("body: \(String(describing: resultString))")
        }
    }

    public func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print("responseData: \(String(describing: dataDict))")
        }
    }

    public func log(error: Error) {
        print("\(error)")
    }
}

public final class ImplAPIService {
    
    private let networkService: NetworkService
    private let errorResolver: APIErrorResolver
    private let errorLogger: APIErrorLogger
    
    public init(with networkService: NetworkService,
                errorResolver: APIErrorResolver = ImplErrorResolver(),
                errorLogger: APIErrorLogger = ImplErrorLogger()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

extension ImplAPIService: APIService {
    
    public func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                              completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T {

        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, APIError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async { return completion(result) }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async { return completion(.failure(error)) }
            }
        }
    }

    public func request<E>(with endpoint: E, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E : ResponseRequestable, E.Response == Void {
        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success:
                DispatchQueue.main.async { return completion(.success(())) }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async { return completion(.failure(error)) }
            }
        }
    }

    // MARK: - Private
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, APIError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> APIError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}

// MARK: - Logger
public final class ImplErrorLogger: APIErrorLogger {
    public init() { }
    
    public func log(error: Error) {
        print("-------------")
        print("\(error)")
    }
}

// MARK: - Error Resolver
public class ImplErrorResolver: APIErrorResolver {
    public init() { }
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}

public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    public init() { }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
