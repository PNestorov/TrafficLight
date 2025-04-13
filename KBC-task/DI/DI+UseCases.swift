//
//  DI+UseCases.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//

import Factory

extension Container {
    var getCarValidationUC: Factory<CarValidationUCProtocol> {
        self { CarValidationUC() }.unique
    }
    
    var getCarPublisherUC: Factory<GetCarPublisherUCProtocol> {
        self { GetCarPublisherUC() }.unique
    }    
}
