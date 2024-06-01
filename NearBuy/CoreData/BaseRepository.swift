//
//  BaseRepository.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

protocol BaseRepository {
    associatedtype T
    
    func create(data: T)
    func getAll() -> [T]?
    func deleteAll()
}
