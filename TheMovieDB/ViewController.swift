//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 14/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var peliculasTableView: UITableView!
    var peliculas = [Pelicula]()
    
    private var peliculasManager = PeliculasManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        peliculasManager.delegate = self
        peliculasManager.obtenerTopPeliculas()
    }


}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaPelicula")!
        
        cell.textLabel?.text = peliculas[indexPath.row].title
        
        return cell
    }
}

// MARK: - PeliculasDelegate
extension ViewController: PeliculasDelegate {
    func estaCargando(_ peliculasManager: PeliculasManager, cargando: Bool) {
        if cargando {
            self.mostrarCargando()
        } else {
            self.removerCargando()
        }
    }
    
    func obtuvoPeticionExitosa(_ peliculasManager: PeliculasManager, peliculas: [Pelicula]) {
        self.peliculas = peliculas
        
        DispatchQueue.main.async {
            self.peliculasTableView.reloadData()
        }
    }
    
    func obtuvoPeticionError(error: Error) {
        
    }
    
    
}
