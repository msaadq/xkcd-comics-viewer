//
//  APIService.swift
//  nurul-courses-ios
//
//  Created by Saad Qureshi on 05/03/2020.
//  Copyright © 2020 Nur-Ul-Quran. All rights reserved.
//

import Foundation
import Combine
import UIKit



// MARK: - APIService
class APIService {
    
    // MARK: - Public API
    static let shared = APIService()

    static let comicBaseURL = URL(string: "http://xkcd.com/")!
    static let comicSearchBaseURL = URL(string: "https://relevantxkcd.appspot.com/")!
    static let comicExplanationBaseURL = URL(string: "https://www.explainxkcd.com/wiki/index.php/")!
    static let retryOccurence: Int = 3
    
    let decoder = JSONDecoder()

    // MARK: - Errors
    enum APIError: Error {
        case decodingError
        case httpError
        case unknownError(error: Error)
    }

    // MARK: - End points
    enum Endpoint {
        case latest
        case comicByID(id: Int)
        case search(name: String)
        case explain(id: Int)

        func path() -> String {
            switch self {
            case .latest:
                return "info.0.json"
            case let .comicByID(id):
                return "\(id)/info.0.json"
            case let .search(name):
                return "process?action=xkcd&query=\(name)}"
            case let .explain(id):
                return "\(id)"
            }
        }
    }

    // MARK: - URL Request Mapper
    func getAPIResponseMapper<T: Codable>(modelObject: T.Type, baseURL: URL? = comicBaseURL, endpoint: Endpoint) -> AnyPublisher<T, APIService.APIError> {
        var request = URLRequest(url: URL(string: baseURL!.absoluteString + endpoint.path())!)
        request.httpMethod = "GET"

        return getRemoteDataPublisher(url: request)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError{ error in
                if type(of: error) == Swift.DecodingError.self {
                    print("JSON decoding error")
                    return APIError.decodingError
                }
                return APIError.unknownError(error: error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Image Fetcher
    func getImageFetcher(imageUrl: URL) -> AnyPublisher<UIImage, Never> {
        var request = URLRequest(url: imageUrl)
        request.httpMethod = "GET"

        return getRemoteDataPublisher(url: request)
            .tryMap { data in
                guard let image = UIImage(data: data) else {
                    print("Image decoding error")
                    throw APIError.decodingError
                }
                return image
            }
            .replaceError(with: UIImage(named: "FailedPlaceholder")!)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private URL Request Publisher
    private func getRemoteDataPublisher(url: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
        .retry(APIService.retryOccurence)
        .tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Error")
                throw APIError.httpError
            }
            return data
        }
        .mapError { error in
            print(error.localizedDescription)
            return APIError.unknownError(error: error)
        }
        .eraseToAnyPublisher()
    }
}