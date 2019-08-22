//
//  TableViewCellProtocol.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit

protocol TableViewCell {
    static var cellIdentifier: String { get }
    static func nib() -> UINib
}

extension UITableViewCell: TableViewCell {
    static var cellIdentifier: String {
        get {
            let fullName = NSStringFromClass(self)
            let className = fullName.components(separatedBy: ".")[1]
            return className
        }
    }
    
    static func nib() -> UINib {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        return UINib(nibName: className, bundle: Bundle.main)
    }
}
