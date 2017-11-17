//
//  DelaingObservable.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 16.11.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import Foundation
import RxSwift

class DelaingObservable  {
    
    private let delay: Double
    
    init(delay: Double) {
        self.delay = delay
    }
    
    var idk: Single<Void> {
        return Observable<Int>.timer(self.delay, period: self.delay, scheduler: MainScheduler.instance).take(1)
            .map { (_) -> Void in
                return
            }.asSingle()
    }
    
}
