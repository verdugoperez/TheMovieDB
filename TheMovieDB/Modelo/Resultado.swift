//
//  Resultado.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 14/09/21.
//

import Foundation

struct Resultado: Codable {
    var page: Int
    var results: [Pelicula]
    var totalPages: Int
    var totalResults: Int
}
