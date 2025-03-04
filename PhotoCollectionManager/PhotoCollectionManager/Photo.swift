//
//  Photo.swift
//  PhotoCollectionManager
//
//  Created by Elaine G on 2025-02-22.
//

import Foundation
import SwiftUI

struct Photo: Identifiable, Codable {
    let id: UUID
    var name: String
    var location: String
    var category: Category
    var imgUrl: URL?
    var date: Date
    
 
}
