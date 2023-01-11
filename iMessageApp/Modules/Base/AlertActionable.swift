//
//  AlertActionable.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import Foundation

enum Alert: AlertActionable {
    case ok, delete, cancel
    
    var title: String {
        switch self {
            case .ok: return "Ok"
            case .delete: return "Delete"
            case .cancel: return "Cancel"
        }
    }
    
    var destructive: Bool {
        switch self {
            case .ok, .cancel: return false
            case .delete: return true
        }
    }
}

/// The alert protocol
protocol AlertActionable {
    var title: String { get }
    var destructive: Bool { get }
}
