//
//  PeliculaDetalleViewController.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 15/09/21.
//

import UIKit

class PeliculaDetalleViewController: UIViewController {
    
    var pelicula: Pelicula!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = pelicula.title
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
