//
//  Extensions.swift
//  TheMovieDB
//
//  Created by Manuel Alejandro Verdugo Pérez on 14/09/21.
//

import UIKit

fileprivate var child: LoadingViewController!

extension UIViewController {
    func mostrarCargando(){
        DispatchQueue.main.async {
            child = LoadingViewController()
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
        }
    }
    
    func removerCargando(){
        DispatchQueue.main.async {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    func mostrarAlerta(mensaje: String){
        let alert = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))


        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

extension Date {
    func convertirAString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    func convertirAFecha() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd"
        
        return dateFormatter.date(from: self)
    }
}
