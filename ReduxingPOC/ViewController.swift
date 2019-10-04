//
//  ViewController.swift
//  ReduxingPOC
//
//  Created by Felipe Borges Bezerra on 19/09/19.
//  Copyright © 2019 Felipe Borges Bezerra. All rights reserved.
//

import UIKit

let mainStore = Store<AppState>(
    reducer: counterReducer,
    initialState: AppState(counter: 0))

// Abort
class ViewController: UIViewController, Subscriber {
    typealias State = AppState
    
    func newState(_ state: ViewController.State) {
        counterLabel.text = "\(state.counter)"
    }

    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStore.subscribe(self)
    }
    
    @IBAction func increaseTapped(_ sender: Any) {
        mainStore.dispatch(
            action: CounterAction.increase
        )
    }
    
    @IBAction func decreaseTapped(_ sender: Any) {
        mainStore.dispatch(
            action: CounterAction.decrease
        )
    }
}

struct AppState: ReduxState, Codable {
    var counter: Int = 0
}

enum CounterAction: Action {
    case increase, decrease
}

let counterReducer: Reducer<AppState> = {( state, action) -> AppState in
    var state = state
    guard let counterAction = action as? CounterAction else {
        return state
    }
    
    switch counterAction {
    case .increase:
        state.counter += 1
    case .decrease:
        state.counter -= 1
    }
    
    return state
}

