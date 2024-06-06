//
//  DetailBuilder.swift
//  MarvelApp
//
//  Created by Baran Baran on 1.06.2024.
//

import Foundation


enum DetailBuilder {
    static func build(with results: Results, isFromFavorites: Bool) -> DetailViewController {
        let worker = DetailWorker()
        let interactor = DetailInteractor(worker: worker)
        let vc = DetailViewController(selectedCharacter: results, interactor: interactor, isFromFavorites: isFromFavorites)
        return vc
    }
}
