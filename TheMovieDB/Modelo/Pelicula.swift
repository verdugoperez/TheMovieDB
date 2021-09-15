//
//  Pelicula.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 14/09/21.
//

import Foundation

struct Pelicula: Codable {
    var adult: Bool
    var backdropPath: String
    var genreIds: [Int]
    var id: Int
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var popularity: Float
    var posterPath: String
    var releaseDate: String
    var title: String
    var video: Bool
    var voteAverage: Float
    var voteCount: Int
}
