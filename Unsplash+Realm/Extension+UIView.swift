//
//  Extension+UIView.swift
//  Unsplash+Realm
//
//  Created by Алексей on 25.03.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
