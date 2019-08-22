//
//  CharacterTableViewCell.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 20/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func setView(characterName: String, avatarString: String) {
        titleLabel.text = characterName
        self.avatarImageView.image = avatarString.getImageFromUrlString()
    }
}
