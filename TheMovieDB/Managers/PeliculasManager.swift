//
//  PeliculasManager.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 14/09/21.
//

import UIKit

enum TipoImagen: String  {
    case poster = "w185"
    case backDrop = "w1280"
}

protocol PeliculasDelegate {
    func obtuvoPeticionExitosa(_ peliculasManager: PeliculasManager, peliculas: [Pelicula])
    func estaCargando(_ peliculasManager: PeliculasManager, cargando: Bool)
    func obtuvoPeticionError(error: Error)
}

class PeliculasManager {
    
    private let url =  "https://api.themoviedb.org/3/discover/movie?api_key=b3fe9a9f3bbf3b29fcee2b8c03ac45ef"
    private let urlImagen = "https://image.tmdb.org/t/p"
    private let persistenceManager = PersistenceManager()
    private let defaults = UserDefaults.standard
    private let cache = NSCache<NSString, UIImage>()
    
    var delegate: PeliculasDelegate?
    
    func obtenerTopPeliculas() {
        let urlString = "\(url)"
        
        ejecutarRequest(with: urlString)
    }
    
    func ejecutarRequest(with urlString: String){
        
        // Mostrar peliculas cargadas en UserDefaults si el ultimo consumo se hizo en las ultimas 24 horas
        if let fecha = persistenceManager.obtenerUltimoConsumo() {
            let diferencia = Calendar.current.dateComponents([.hour, .minute, .second], from: fecha, to: Date())
            if let horas = diferencia.hour {
                if horas <= 24 {
                    persistenceManager.obtenerPeliculasGuardadas { result in
                      switch result {
                          case .success(let peliculas):
                            self.delegate?.obtuvoPeticionExitosa(self, peliculas: peliculas)
                           
                          case .failure(let error):
                            self.delegate?.obtuvoPeticionError(error: error)
                            
                      }
                    }
                    
                    return
                }
            }
        }
        
        if let url = URL(string: "\(urlString)&page=\(persistenceManager.obtenerPagina())"){
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
                        self.persistenceManager.guardarFechaUltimoConsumo()
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
        let pagina = persistenceManager.obtenerPagina()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let decodedData = try decoder.decode(Resultado.self, from: peliculasData)
            let decodedPeliculas = decodedData.results
            
            if let error = persistenceManager.guardarPeliculas(peliculas: decodedPeliculas) {
                delegate?.obtuvoPeticionError(error: error)
            }
            
            if pagina < decodedData.totalPages {
                self.persistenceManager.guardarPagina(pagina: pagina + 1)
            }
            
            return decodedPeliculas
         
        } catch {
            delegate?.obtuvoPeticionError(error: error)
            return nil
        }
    }
    
    func descargarImagen(from urlString: String, tipoImagen: TipoImagen? = .poster, completion: @escaping(UIImage?) -> Void){
        // Regresar imagen si ya está en cache
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey){
            completion(image)
            return
        }
        
        guard let url = URL(string: "\(urlImagen)/\(tipoImagen!.rawValue)\(urlString)") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self]  data, response, error in
            guard let self = self,
                 error == nil,
                 let response = response as? HTTPURLResponse, response.statusCode == 200,
                 let data = data,
                 let image = UIImage(data: data) else {
                       completion(nil)
                       return
            }
            
            // guardar la imagen en cache
            self.cache.setObject(image, forKey: cacheKey)
            
            completion(image)
        }
        
        task.resume()
    }
}
