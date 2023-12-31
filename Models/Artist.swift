//
//  Artist.swift
//  LuyenVoCong
//
//  Created by Dinh Pham Kha on 02/08/2023.
//

import Foundation
struct Artist : Codable{
    let id : String
    let name : String
    let type : String
    let external_urls : [String : String]
}
