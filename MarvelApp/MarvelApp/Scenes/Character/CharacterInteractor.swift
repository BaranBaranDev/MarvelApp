//
//  CharacterInteractor.swift
//  MarvelApp
//
//  Created by Baran Baran on 6.06.2024.



// MARK:  CharacterBusinessLogic
protocol CharacterBusinessLogic {
    func fetchCharecter(request: CharacterModels.fetchCharacter.Request)
}

// MARK:  CharacterDataStore
protocol CharacterDataStore {
    var selectedCharecter: Results? { get set }
}


final class CharacterInteractor: CharacterDataStore {
    
    //MARK: DataStore Logic
     var selectedCharecter: Results?
    
    //MARK: Dependencies
    private let worker: CharecterNetworkWorker
    private let presenter: CharacterPresentetionLogic
    
    init(selectedCharecter: Results? = nil, worker: CharecterNetworkWorker, presenter: CharacterPresentetionLogic) {
        self.selectedCharecter = selectedCharecter
        self.worker = worker
        self.presenter = presenter
    }
    
    
}


extension CharacterInteractor: CharacterBusinessLogic {
    func fetchCharecter(request: CharacterModels.fetchCharacter.Request) {
        worker.fetchCharacterList { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let marvelRes):
                guard let results = marvelRes.data?.results else { return }
                presenter.presentFetchCharecter(response: CharacterModels.fetchCharacter.Response(characterList: results))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
