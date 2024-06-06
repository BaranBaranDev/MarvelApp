//
//  FavoritesModels.swift
//  MarvelApp
//
//  Created by Baran Baran on 3.06.2024.
//


import UIKit

enum FavoritesModels
{
    // MARK: FetchDatabase
    enum FetchDatabase
    {
        struct Request {}
        struct Response {
            let fetchItems: [FavoriteCharacter]
        }
        struct Viewmodel {
            let fetchItems: [FavoriteCharacter]
        }
    }
    
    
    // MARK: DeleteDatabase
    enum DeleteDatabase {
           struct Request {
               let item: FavoriteCharacter
           }
           struct Response {
               let success: Bool
           }
           struct Viewmodel {
               let success: Bool
           }
       }
    
}
