//
//  Observable.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import Foundation

class Observable<T> {
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    
    // Just bind to this listener
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    // Bind and fire initial value using it
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
