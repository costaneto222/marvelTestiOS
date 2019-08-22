//
//  Storyboarded.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 20/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit

protocol Storyboarded {
    func instantiate(fromStoryboard storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(fromStoryboard storyboardName: String) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        debugPrint("****- \(className)")
        //TODO: TRAIT THIS FORCE CAST
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
