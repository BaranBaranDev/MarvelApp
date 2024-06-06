//
//  FavoritesInteractor.swift
//  MarvelApp
//
//  Created by Baran Baran on 3.06.2024.z





import UIKit

protocol FavoritesBusinessLogic {
    func fetchDatabase(request: FavoritesModels.FetchDatabase.Request)
    func deleteDatabase(request: FavoritesModels.DeleteDatabase.Request)
}



// MARK:  FavoritesDataStore
protocol FavoritesDataStore {
    var selectedCharecter: Results? { get set }
}




final class FavoritesInteractor: FavoritesDataStore {
    
    // DataStore logic
    var selectedCharecter: Results?
    
    
    //MARK: Dependencies
    private let worker: FavoritesDataWorkerProtocol
    private let presenter: FavoritesPresentationLogic
    
    
    init(worker: FavoritesDataWorkerProtocol, presenter: FavoritesPresentationLogic) {
        self.worker = worker
        self.presenter = presenter
    }
}


extension FavoritesInteractor: FavoritesBusinessLogic {
    
    // Verileri çekme
    func fetchDatabase(request: FavoritesModels.FetchDatabase.Request) {
        worker.fetchDatabase { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.presenter.presentFetchData(response: FavoritesModels.FetchDatabase.Response(fetchItems: data))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Verileri silme
    func deleteDatabase(request: FavoritesModels.DeleteDatabase.Request) {
           worker.deleteDatabase(deleteItem: request.item) { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success:
                   self.presenter.presentDeleteDatabase(response: FavoritesModels.DeleteDatabase.Response(success: true))
               case .failure(let error):
                   print(error)
                   self.presenter.presentDeleteDatabase(response: FavoritesModels.DeleteDatabase.Response(success: false))
               }
           }
       }
}
