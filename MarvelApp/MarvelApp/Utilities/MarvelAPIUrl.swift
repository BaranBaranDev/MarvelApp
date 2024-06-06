//
//  MarvelAPIUrl.swift
//  MarvelApp
//
//  Created by Baran Baran on 30.05.2024.
//

import Foundation

// MARK: - APIComponent

enum APIComponent: String {
    case baseURL = "https://gateway.marvel.com"
    case path = "/v1/public/characters"
    case ts = "1"
    case apikey = "e78bdf2708317e21d51dc93ff3ddd77c"
    case hash = "c13f40d9e292b6cb2140f53b0292abf2"
}



// MARK: - MarvelAPIUrl

struct MarvelAPIUrl {
    
    static let charactersURL = "\(APIComponent.baseURL.rawValue)\(APIComponent.path.rawValue)?ts=\(APIComponent.ts.rawValue)&apikey=\(APIComponent.apikey.rawValue)&hash=\(APIComponent.hash.rawValue)"
    
    
    static func searchCharacterUrl(term: String) -> String {
        return "\(APIComponent.baseURL.rawValue)\(APIComponent.path.rawValue)?nameStartsWith=\(term)&ts=\(APIComponent.ts.rawValue)&apikey=\(APIComponent.apikey.rawValue)&hash=\(APIComponent.hash.rawValue)"
        
    }
}
