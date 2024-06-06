//
//  CharacterWorker.swift
//  MarvelApp
//
//  Created by Baran Baran on 6.06.2024.



import UIKit

protocol CharecterNetworkWorker: AnyObject {
    func fetchCharacterList( completion: @escaping (Result<MarvelResponse, Error>) -> Void )
}


final class CharacterWorker: CharecterNetworkWorker {
    func fetchCharacterList( completion: @escaping (Result<MarvelResponse, Error>) -> Void ) {
        ServiceManager.shared.fetchData(url: MarvelAPIUrl.charactersURL, completion: completion)
    }
}

