//
//  ObjectConvertible.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 18/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import Foundation

/// An object that wants to be convertible in a managed object should implement the `ObjectConvertible` protocol.
protocol ObjectConvertible {
    /// An identifier that is used to fetch the corresponding database object.
    var identifier: String? { get }
}
