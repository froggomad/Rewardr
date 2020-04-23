//
//  NetworkHelper.swift
//  Rewardr
//
//  Created by Kenny on 4/20/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class NetworkService {

    enum HttpMethod: String {
        case get = "GET"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    /**
     used when the endpoint requires a header-type (i.e. "content-type") be specified in the header
     */
    enum HttpHeaderType: String {
        case contentType = "Content-Type"
    }

    /**
     the value of the header-type (i.e. "application/json")
     */
    enum HttpHeaderValue: String {
        case json = "application/json"
    }
    
    ///contains a header-type and header-value for use in adding values to request headers
    struct HeaderEntry {
        let type: HttpHeaderType
        let value: HttpHeaderValue
    }

    ///used to determine encoding success or failure
    struct EncodingStatus {
        ///should return nil if there's an error or a valid request object if there isn't
        let request: URLRequest?
        ///should return nil if the request succeeded and a valid error if it didn't
        let error: Error?
    }

    struct DownloadStatus {
        let error: Error?
        let data: Data?
    }


    /**
     Create a request given a URL and requestMethod (get, post, create, etc...)
     - parameter url: If the url evaluates to nil, the function will exit immediately
     - parameter method: GET, PATCH, PUT, POST, etc...
     - parameter headerEntries: an optional array of header entries consisting of a HttpHeaderType and HttpHeaderValue
     */
    class func createRequest(url: URL?, method: HttpMethod, headerEntries: [HeaderEntry]? = nil) -> URLRequest? {
        guard let requestUrl = url else {
            NSLog("request URL is nil")
            return nil
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        if let entries = headerEntries {
            for entry in entries {
                request.addValue(entry.value.rawValue, forHTTPHeaderField: entry.type.rawValue)
            }
        }
        return request
    }

    /**
     Encode from a Swift object to JSON for transmitting to an endpoint and returns an EncodingStatus object which should either contain an error and nil request or request and nil error
     - parameter type: the type to be encoded (i.e. MyCustomType.self)
     - parameter request: the URLRequest used to transmit the encoded result to the remote server
     - parameter dateFormatter: optional for use with JSONEncoder.dateEncodingStrategy
     */
    class func encode<T:Encodable>(from type: T, request: inout URLRequest, dateFormatter df: DateFormatter? = nil) -> EncodingStatus {
        let jsonEncoder = JSONEncoder()
        if let df = df {
            jsonEncoder.dateEncodingStrategy = .formatted(df)
        }
        do {
            request.httpBody = try jsonEncoder.encode(type)
        } catch {
            print("Error encoding object into JSON \(error)")
            return EncodingStatus(request: nil, error: error)
        }
        return EncodingStatus(request: request, error: nil)
    }

    class func networkSession(with request: URLRequest, complete: @escaping (DownloadStatus) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error downloading from \(#file) \(#function) \(#line): \(error)")
                complete(DownloadStatus(error: error, data: nil))
            }

            if let data = data {
                complete(DownloadStatus(error: nil, data: data))
            }
        }.resume()
    }

    class func decode<T:Decodable>(to type: T.Type, data: Data, dateFormatter df: DateFormatter? = nil) -> T? {
        let decoder = JSONDecoder()
        if let df = df {
            decoder.dateDecodingStrategy = .formatted(df)
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error Decoding JSON into \(String(describing: type)) Object \(error)")
            return nil
        }
    }
}
