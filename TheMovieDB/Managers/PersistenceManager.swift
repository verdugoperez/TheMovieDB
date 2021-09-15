//
//  PersistenceManager.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 15/09/21.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

class PersistenceManager {
    private let defaults = UserDefaults.standard
    
    func guardarPeliculas(peliculas: [Pelicula]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(peliculas)
            defaults.setValue(encodedFavorites, forKey: UserDefaultKeys.peliculas)
            return nil
        } catch {
            return error
        }
    }
    
    func obtenerPeliculasGuardadas(completion: @escaping(Result<[Pelicula], Error>) -> Void){
        guard let peliculasData = defaults.object(forKey: UserDefaultKeys.peliculas) as? Data else {
            completion(.success([]))
            return
        }
          
          do {
              let decoder = JSONDecoder()
          
              let peliculas = try decoder.decode([Pelicula].self, from: peliculasData)
              completion(.success(peliculas))
          } catch {
            completion(.failure(error))
          }
      }
    
    func guardarFechaUltimoConsumo(){
        defaults.setValue(Date(), forKey: UserDefaultKeys.fechaUltimoConsumo)
    }
    
    func obtenerUltimoConsumo() -> Date? {
        let fecha = UserDefaults.standard.object(forKey: UserDefaultKeys.fechaUltimoConsumo) as? Date

        return fecha
    }
}
