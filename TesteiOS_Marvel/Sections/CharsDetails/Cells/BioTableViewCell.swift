//
//  BioTableViewCell.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit

class BioTableViewCell: UITableViewCell {
    @IBOutlet weak var shortBioLabel: UILabel!
    
    func setPersonaBiography(_ bioString: String) {
        shortBioLabel.text = bioString
    }
}
