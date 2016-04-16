//
//  NamedEntity.swift
//  SafeRide
//
//  Created by Caleb Friden on 4/16/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import Foundation


public protocol NamedEntity {
    static var entityName: String { get }
}