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
}
