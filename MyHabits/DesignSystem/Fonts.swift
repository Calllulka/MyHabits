//
//  Fonts.swift
//  MyHabits
//
//  Created by Alexander on 15.03.2023.
//

import UIKit

extension UIFont {
    static var title3: UIFont {
        UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    static var headline: UIFont {
        UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    static var body: UIFont {
        UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    static var footnote: UIFont {
        UIFont.systemFont(ofSize: 13, weight: .semibold)
    }
    static var footnoteStatus: UIFont {
        UIFont.systemFont(ofSize: 13, weight: .semibold)
    }
    static var footnoteGray: UIFont {
        UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    static var caption: UIFont {
        UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}
