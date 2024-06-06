//
//  FavoritesWorker.swift
//  MarvelApp
//
//  Created by Baran Baran on 3.06.2024.


import UIKit



protocol FavoritesDataWorkerProtocol {
    func fetchDatabase(completion: @escaping(Result<[FavoriteCharacter],Error>) -> Void)
    func deleteDatabase(deleteItem: FavoriteCharacter, completion: @escaping(Result<Void,Error>) -> Void)
}


final class FavoritesWorker: FavoritesDataWorkerProtocol {
    func fetchDatabase(completion: @escaping (Result<[FavoriteCharacter], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let request = FavoriteCharacter.fetchRequest()
        do {
            let data = try context.fetch(request)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
    

    func deleteDatabase(deleteItem: FavoriteCharacter, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        context.delete(deleteItem)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
