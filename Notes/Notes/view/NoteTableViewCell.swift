//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 11/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    // MARK: Initial setup

    func setNoteData(for note: Note) {
        self.backgroundColor = .clear

        titleLabel?.text = note.title
        subtitleLabel?.text = note.text
    }
}
