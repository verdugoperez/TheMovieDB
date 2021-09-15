//
//  PeliculasManager.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 14/09/21.
//

import UIKit

protocol PeliculasDelegate {
    func obtuvoPeticionExitosa(_ peliculasManager: PeliculasManager, peliculas: [Pelicula])
    func estaCargando(_ peliculasManager: PeliculasManager, cargando: Bool)
    func obtuvoPeticionError(error: Error)
}

struct PeliculasManager {
    let url =  "https://api.themoviedb.org/3/discover/movie?api_key=b3fe9a9f3bbf3b29fcee2b8c03ac45ef"
    let urlImagen = "https://image.tmdb.org/t/p/w185"
    
    var delegate: PeliculasDelegate?
    
    func obtenerTopPeliculas() {
        let urlString = "\(url)"
        
        ejecutarRequest(with: urlString)
    }
    
    func ejecutarRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            self.delegate?.estaCargando(self, cargando: true)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.obtuvoPeticionError(error: error!)
                    self.delegate?.estaCargando(self, cargando: false)
                    return
                }
                
                if let safeData = data {
                    if let peliculas = self.parseJSON(safeData) {
                        
                        self.delegate?.obtuvoPeticionExitosa(self, peliculas: peliculas)
                    }
                    
                }
            }
            
            self.delegate?.estaCargando(self, cargando: false)
            task.resume()
        }
    }
    
    func parseJSON(_ peliculasData: Data) -> [Pelicula]? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let decodedData = try decoder.decode(Resultado.self, from: peliculasData)
             
            return decodedData.results
         
        } catch {
            delegate?.obtuvoPeticionError(error: error)
            return nil
        }
    }
    
    func descargarImagen(from urlString: String, completion: @escaping(UIImage?) -> Void){
        guard let url = URL(string: "\(urlImagen)\(urlString)") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                        completion(nil)
                        return
                  }
            
            completion(image)
        }
        
        task.resume()
    }
}
