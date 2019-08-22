//
//  String+Extension.swift
//  TesteiOS_Marvel
//
//  Created by Francisco de Carvalho Costa Neto on 22/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit

extension String {
    func getImageFromUrlString() -> UIImage? {
        guard let imageUrl = URL(string: self),
            let data = try? Data(contentsOf: imageUrl),
            let image = UIImage(data: data) else { return nil }
        return image
    }
}
