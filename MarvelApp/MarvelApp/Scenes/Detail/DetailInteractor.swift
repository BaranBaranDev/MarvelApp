//
//  DetailInteractor.swift
//  MarvelApp
//
//  Created by Baran Baran on 1.06.2024.



import UIKit

protocol DetailBusinessLogic {
    func saveData(request: DetailModels.saveData.Request)
}



final class DetailInteractor {

    //MARK: Dependencies
    private let worker: DetailDataWorkerProtocol
    
    init(worker: DetailDataWorkerProtocol) {
        self.worker = worker
    }
}


extension DetailInteractor: DetailBusinessLogic {
    func saveData(request: DetailModels.saveData.Request) {
        worker.saveFavoriteCharacter(model: request.selectedItem) { result in
            NotificationCenter.default.post(name: NSNotification.Name("Favorites"), object: nil)
            print("Success Save Data")
        }
    }
    
}
