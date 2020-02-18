//
//  NoteLocal.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 17/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import Foundation

struct NoteLocal : ObjectConvertible {
    var title: String
    var text: String?
    var timestamp: String?
    
    private(set) var identifier: String?

    init(title: String, text: String?, timestamp: String?, identifier: String? = nil) {
        self.title = title
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
