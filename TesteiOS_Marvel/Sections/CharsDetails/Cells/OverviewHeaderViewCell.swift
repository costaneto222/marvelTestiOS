//
//  OverviewHeaderView.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OverviewHeaderViewCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var profileTypeSControl: UISegmentedControl!
    
    private(set) var disposeBag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.disposeBag = DisposeBag()
    }
    
    func configOverviewWith(avatarImage image: UIImage?) {
        avatarImageView.image = image
    }
}
