//
//  State.swift
//  ReduxingPOC
//
//  Created by Felipe Borges Bezerra on 23/09/19.
//  Copyright © 2019 Felipe Borges Bezerra. All rights reserved.
//

import Foundation

protocol Action { }

protocol ReduxState { }

typealias Reducer <S: ReduxState> = (S, Action) -> S

