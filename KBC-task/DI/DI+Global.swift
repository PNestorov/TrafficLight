//
//  DI+Global.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//

import Factory

extension Container {
    var getAppCoordinator: Factory<AppCoordinator> {
        self { AppCoordinator() }.singleton
    }
}
