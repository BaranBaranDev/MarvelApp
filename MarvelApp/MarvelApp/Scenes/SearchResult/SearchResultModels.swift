//
//  SearchResultModels.swift
//  MarvelApp
//
//  Created by Baran Baran on 31.05.2024.
//


import UIKit

enum SearchResultModels {
    
    enum search {
        struct Request {
            let searchText: String
        }
        struct Response {
            let characterList : [Results]
        }
        struct Viewmodel {
            let characterList : [Results]
        }
    }
    
}
