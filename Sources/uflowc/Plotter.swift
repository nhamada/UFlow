//
//  Plotter.swift
//  uflowc
//
//  Created by Naohiro Hamada on 2017/12/31.
//

import Foundation
import UFlow

/**
 * User flow plotter protocol.
 *
 * To draw or render user flow, a class/struct which conforms this protocol is required.
 */
protocol Plotter {
    /**
     * File extension of output user flow.
     */
    static var fileExtension: String { get }
    
    /**
     * Draw/Render a given user flow to output directory.
     *
     * - parameters:
     *   - document: User flow to draw/render
     *   - outputDirecotyr: Output directory
     */
    static func plot(document: Document, to outputDirectory: URL)
}
