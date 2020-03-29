//
//  shared.swift
//  Coronavirus2019
//
//  Created by Mia Tsung on 3/10/20.
//  Copyright © 2020 Mia Tsung. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
    static let didCompleteTask = Notification.Name("didCompleteTask")
    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}
