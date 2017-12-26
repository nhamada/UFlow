//
//  FileInfo.swift
//  UFlow
//
//  Created by Naohiro Hamada on 2017/12/25.
//

import Foundation

/**
 * Data container for file info
 */
public struct FileInfo {
    /// Key definition of dictionary containing file info
    private enum Keys: String {
        case title = "title"
        case project = "project"
        case summary = "summary"
        case version = "version"
        case tags = "tags"
        case date = "date"
        case authors = "authors"
    }
    
    /// Title of the user flow
    public let title: String
    /// Project name which contains this user flow
    public let project: String?
    /// Description/summary of the user flow
    public let summary: String?
    /// Version string of the user flow
    public let version: String?
    /// List of tags assigned to the user flow
    public let tags: [String]?
    /// Publication date
    public let date: Date?
    /// List of authors
    public let authors: [String]?
    
    /**
     * Initialize file info from a given dictionary.
     *
     * - parameters:
     *   - dictionary: Dictionary which contains file info
     */
    public init(from dictionary: [String:Any]) {
        guard let title = dictionary[Keys.title.rawValue] as? String else {
            fatalError("Missing `title`")
        }
        self.title = title
        self.project = dictionary[Keys.project.rawValue] as? String
        self.summary = dictionary[Keys.summary.rawValue] as? String
        self.version = dictionary[Keys.version.rawValue] as? String
        self.tags = dictionary[Keys.tags.rawValue] as? [String]
        self.date = dictionary[Keys.date.rawValue] as? Date
        self.authors = dictionary[Keys.authors.rawValue] as? [String]
    }
}
