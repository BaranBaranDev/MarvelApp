//
//  CharacterModels.swift
//  MarvelApp
//
//  Created by Baran Baran on 6.06.2024.
//


import UIKit

enum CharacterModels {
    enum fetchCharacter {
        struct Request {}
        struct Response {
            let characterList : [Results]
        }
        struct Viewmodel {
            let characterList : [Results]
        }
    }
}
