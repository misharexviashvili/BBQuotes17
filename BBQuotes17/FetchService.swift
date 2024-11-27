//
//  FetchService.swift
//  BBQuotes17
//
//  Created by Misho's Mac on 13.11.24.
//

import Foundation

struct FetchService {
    enum FetchError : Error{
        case badResponse
    }
    let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    func fetchQuote (from show: String) async throws -> Quote {
        //        build fetch url
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name:"production", value: show)])
        //        fetch data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        //        handle response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200
        else {
            throw FetchError.badResponse
        }
        //        decode data
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        //        return quote
        return quote
    }
    func fetchCharacter (_ name : String) async throws -> Character {
        let characterURL = baseURL.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200
        else {
            throw FetchError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let characters = try decoder.decode([Character].self, from: data)
        return characters[0]
    }
    func fetchDeath(for character : String) async throws -> Death? {
        let fetchURL = baseURL.appending(path: "death")
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200
        else {
            throw FetchError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let deaths = try decoder.decode([Death].self, from: data)
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        return nil
    }
}
