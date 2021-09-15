//
//  PeliculaDetalleViewController.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 15/09/21.
//

import UIKit

class PeliculaDetalleViewController: UIViewController {
    
    @IBOutlet weak var portadaImageView: UIImageView!
    var pelicula: Pelicula!
    private let peliculasManager = PeliculasManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = pelicula.title
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
