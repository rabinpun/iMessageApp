//
//  AlertActionable.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import Foundation

enum Alert: AlertActionable {
    case ok
    
    var title: String {
        switch self {
            case .ok: return "Ok"
        }
    }
    
    var destructive: Bool {
        false
    }
}

/// The alert protocol
protocol AlertActionable {
    var title: String { get }
    var destructive: Bool { get }
}
