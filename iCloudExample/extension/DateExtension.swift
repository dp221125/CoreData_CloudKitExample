//
//  DateExtension.swift
//  iCloudExample
//
//  Created by Seokho on 2019/11/27.
//  Copyright © 2019 Seokho. All rights reserved.
//

import Foundation

extension Date {
    func convertString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = LocalList.korea
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: self)
    }
}
