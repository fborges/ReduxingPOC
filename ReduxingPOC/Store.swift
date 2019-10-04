//
//  Store.swift
//  ReduxingPOC
//
//  Created by Felipe Borges Bezerra on 23/09/19.
//  Copyright © 2019 Felipe Borges Bezerra. All rights reserved.
//

import UIKit



protocol StoreType {
    associatedtype S: ReduxState
    
    var subscribers: [AnyStoreSubscriber] { get }
    
    var reducer: Reducer<S> { get }
    
    func dispatch(action: Action, keep: Bool)
    func subscribe<S: Subscriber>(_ subscriber: S)
}

protocol AnyStoreSubscriber: class {
    func _newState(state: Any)
}

protocol Subscriber: AnyStoreSubscriber {
    associatedtype State: ReduxState
    
    func newState(_ state: State)
}

extension Subscriber {
    public func _newState(state: Any) {
        if let typedState = state as? State {
            newState(typedState)
        }
    }
}

class Store<S: ReduxState>: StoreType {
    var subscribers: [AnyStoreSubscriber] = []
    var current: S
    var reducer: Reducer<S>
    
    init(reducer: @escaping Reducer<S>, initialState: S)  {
        current = initialState
        self.reducer = reducer
    }
    
    func dispatch(action: Action, keep: Bool = true) {
        let newState = reducer(current, action)
        current = newState
        subscribers.forEach { $0._newState(state: current as Any) }
    }
    
    func subscribe<S>(_ subscriber: S) where S : Subscriber {
        subscribers.append(subscriber)
        subscriber._newState(state: current)
    }
}
