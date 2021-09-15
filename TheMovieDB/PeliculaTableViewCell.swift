//
//  PeliculaTableViewCell.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 15/09/21.
//

import UIKit

class PeliculaTableViewCell: UITableViewCell {
    
    static let identifier = "peliculaCell"
    private let peliculasManager = PeliculasManager()

    @IBOutlet weak var tituloPelicula: UILabel!
    @IBOutlet weak var imagenPelicula: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configura(pelicula: Pelicula){
        tituloPelicula.text = pelicula.title
        descargarImagen(urlString: pelicula.posterPath)
    }
    
    func descargarImagen(urlString: String){
        peliculasManager.descargarImagen(from: urlString) { [weak self] imagen in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.imagenPelicula.image = imagen
            }
        }
    }
    
}
