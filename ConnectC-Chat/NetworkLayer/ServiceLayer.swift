import Foundation

enum JSONService {
    case login(id: Parameter)
    case fetchHistory (id: Parameter, header: String)
}

/// to provide data to the API Calls
typealias Parameter = [String : Any]

extension JSONService: HTTPClient {
    var host: String {
        return "http://connect-ec-v3.dci.in/api/"
    }
    
    var path: String {
        switch self {
        case .login:
            return "auth/"
        case .fetchHistory:
            return "private-chats/"
        }
    }
    
    var endpoint: String {
        switch self {
        case .login:
            return "login"
        case .fetchHistory:
            return "index"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login,.fetchHistory:
            return .post
        }
    }
    
    var parameters: Parameter? {
        switch self {
        case .login (let id), .fetchHistory (let id, _):
            return id
         
        }
    }
    
    var headers: [String : String]? {
        var setHeader: [String: String] = ["Content-type": "application/json"]
        switch self {
        case .fetchHistory (_, let header):
            setHeader ["Authorization"] = header
         case .login(_):
            return ["Content-type": "application/json"]
        }
        return setHeader
    }
}

/// HTTP Methods
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

/// HTTPClient Errors
enum HTTPClientError: Error {
    case badURL
}

/// The protocol used to define the specifications necessary for a `HTTPClient`.
public protocol HTTPClient {
    /// The host, conforming to RFC 1808.
    var host: String { get }
    
    /// The path, conforming to RFC 1808
    var path: String { get }
    
    /// API Endpoint
    var endpoint: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    /// The HTTP request parameters.
    var parameters: [String: Any]? { get }
    
    /// A dictionary containing all the HTTP header fields
    var headers: [String: String]? { get }
}

extension HTTPClient {
    /// The URL of the receiver.
    fileprivate var url: String {
        return host + path + endpoint
    }

    func request<T: Codable>(type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(.failure(HTTPClientError.badURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                completionHandler(.failure(error))
                return
            }
        }

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            if let data = data {
                do {
                    completionHandler(.success(try JSONDecoder().decode(type, from: data)))
                } catch {
                    completionHandler(.failure(error))
                    return
                }
            }
        })

        dataTask.resume()
    }
}
