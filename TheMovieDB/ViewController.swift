//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 14/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    var peliculas = ["P1", "P2", "P3", "P4", "P5"]
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
        
        cell.textLabel?.text = peliculas[indexPath.row]
        
        return cell
    }
}

extension ViewController: PeliculasDelegate {
    func obtuvoPeticionExitosa(_ peliculasManager: PeliculasManager, peliculas: [Pelicula]) {
        
    }
    
    func obtuvoPeticionError(error: Error) {
        
    }
    
    
}
