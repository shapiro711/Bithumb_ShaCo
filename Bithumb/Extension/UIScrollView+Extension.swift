//
//  UIScrollView+Extension.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/02/01.
//

import UIKit

extension UIScrollView {
    func scrollToCenter() {
        let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2.1)
        setContentOffset(centerOffset, animated: false)
    }
}
