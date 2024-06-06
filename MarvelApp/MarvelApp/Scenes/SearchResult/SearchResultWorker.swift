//
//  SearchResultWorker.swift
//  MarvelApp
//
//  Created by Baran Baran on 31.05.2024.

import UIKit

protocol SearchResultNetworkWorker: AnyObject {
    func searchCharecter(searchText: String, completion: @escaping (Result<MarvelResponse, Error>) -> Void )
}


final class SearchResultWorker: SearchResultNetworkWorker {
    
    func searchCharecter(searchText: String, completion: @escaping (Result<MarvelResponse, Error>) -> Void ){
        ServiceManager.shared.fetchData(url: MarvelAPIUrl.searchCharacterUrl(term: searchText), completion: completion)
    }
    
}

