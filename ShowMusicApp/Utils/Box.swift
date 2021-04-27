//
//  Box.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/27/21.
//

// Simple React
class Box<T>{
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet{
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }    
    
    func bind(listener: Listener?){
        self.listener = listener
        listener?(value)
    }
    
    func unbind() {
        self.listener = nil
    }
}
