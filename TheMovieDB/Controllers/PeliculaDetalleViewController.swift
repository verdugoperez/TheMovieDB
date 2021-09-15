//
//  PeliculaDetalleViewController.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 15/09/21.
//

import UIKit

class PeliculaDetalleViewController: UIViewController {
    
    @IBOutlet weak var portadaImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var calificacionLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    
    var pelicula: Pelicula!
    private let peliculasManager = PeliculasManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        actualizaUI()
    }
    
    private func actualizaUI(){
        self.title = pelicula.title
        overviewLabel.text = pelicula.overview
        calificacionLabel.text = "\(pelicula.voteAverage) ⭐️"
        fechaLabel.text = pelicula.releaseDate.convertirAFecha()?.convertirAString()
        obtenerImagenPortada()
    }
    
    private func obtenerImagenPortada(){
        peliculasManager.descargarImagen(from: pelicula.backdropPath, tipoImagen: .backDrop) { [weak self ]imagen in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.portadaImageView.image = imagen
            }
        }
    }
}
