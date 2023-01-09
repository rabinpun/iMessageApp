//
//  BaseViewModel.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import Foundation
import Combine

class BaseViewModel {

    /// The subcription cancellable bag
    public var bag: Set<AnyCancellable>

    public init() {
        self.bag = Set<AnyCancellable>()
    }
}
