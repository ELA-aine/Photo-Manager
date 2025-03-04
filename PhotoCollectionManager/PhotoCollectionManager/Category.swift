//
//  Category.swift
//  PhotoCollectionManager
//
//  Created by Elaine G on 2025-02-22.
//
import SwiftUI
import Foundation


enum Category: String, Codable, CaseIterable{
    case all = "All"
    case portrait = "Portrait"
    case street = "Street"
    case nature = "Nature"
    case other = "Other"
    
}
