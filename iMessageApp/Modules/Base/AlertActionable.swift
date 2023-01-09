//
//  AlertActionable.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import Foundation

/// The alert protocol
public protocol AlertActionable {
    var title: String { get }
    var destructive: Bool { get }
}
