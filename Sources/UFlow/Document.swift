//
//  Document.swift
//  UFlow
//
//  Created by Naohiro Hamada on 2017/12/25.
//

/**
 * Data container for single document
 */
public struct Document {
    /// File info section
    public let info: FileInfo
    /// Screens section
    public let screens: [Screen]
    
    public init(from dictionary: [String:Any]) {
        info = FileInfo(from: dictionary)
        
        guard let screens = dictionary["screens"] as? [[String:Any]] else {
            fatalError("No screens")
        }
        self.screens = screens.map { Screen(from: $0) }
    }
}
