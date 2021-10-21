//
//  DeviceUtils.swift
//  taskApp
//
//  Created by Олимджон Садыков on 21.10.2021.
//

import Foundation
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
