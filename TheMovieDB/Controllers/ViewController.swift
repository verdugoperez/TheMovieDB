//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 14/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var peliculasTableView: UITableView!

    private var peliculas = [Pelicula]()
    private var peliculasManager = PeliculasManager()
    private var persistenceManager = PersistenceManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        peliculasManager.delegate = self
        configuraCelda()
        cargarPeliculas()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.peliculaDetalle {
            let peliculaDetalleVC = segue.destination as! PeliculaDetalleViewController
            
            if let indexPath = self.peliculasTableView.indexPathForSelectedRow {
                let peliculaSeleccionada = peliculas[indexPath.row]
                peliculaDetalleVC.pelicula = peliculaSeleccionada
            }
        }
    }

    private func configuraCelda(){
        peliculasTableView.register(UINib(nibName: "PeliculaTableViewCell", bundle: nil), forCellReuseIdentifier: PeliculaTableViewCell.identifier)
    }
    
    
    private func cargarPeliculas(){
        persistenceManager.obtenerPeliculasGuardadas { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let peliculas):
                    if peliculas.isEmpty {
                        self.peliculasManager.obtenerTopPeliculas()
                    } else {
                        self.peliculas = peliculas
                    }
                case .failure(let error):
                    self.mostrarAlerta(mensaje: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeliculaTableViewCell.identifier) as! PeliculaTableViewCell
        let pelicula =  peliculas[indexPath.row]
        
        cell.configura(pelicula: pelicula)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.peliculaDetalle, sender: self)
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
        mostrarAlerta(mensaje: error.localizedDescription)
    }
}
