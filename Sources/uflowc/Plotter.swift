//
//  Plotter.swift
//  uflowc
//
//  Created by Naohiro Hamada on 2017/12/31.
//

import Foundation
import UFlow

protocol Plotter {
    static var fileExtension: String { get }
    
    static func plot(document: Document, to outputDirectory: URL)
}
