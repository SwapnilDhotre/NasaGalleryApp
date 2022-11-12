//
//  NetworkManager.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    private var cancellables = Set<AnyCancellable>()
    private let url = "https://raw.githubusercontent.com/obvious/take-home-exercise-data/trunk/nasa-pictures.json"
    
    // Get gallery data from api
    func getGalleryData<T: Decodable>(type: T.Type) -> Future<[T], Error> {
        return Future<[T], Error> { [weak self] promise in
            guard let self = self, let url = URL(string: self.url) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data: Data, response: URLResponse) in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                            
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknownError))
                        }
                    }
                } receiveValue: { receivedData in
                    promise(.success(receivedData))
                }
                .store(in: &self.cancellables)
        }
    }
}
