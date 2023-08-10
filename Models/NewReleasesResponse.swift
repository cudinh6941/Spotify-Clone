//
//  NewReleasesResponse.swift
//  LuyenVoCong
//
//  Created by Dinh Pham Kha on 10/08/2023.
//

import Foundation

struct NewReleaseResponese : Codable{
    let albums : AlbumsResponse
}
struct AlbumsResponse : Codable{
    let items : [Album]
}
struct Album : Codable{
    let album_type : String
    let available_markets : [String]
    let id : String
    let images : [APIImage]
    let name : String
    let release_date : String
    let total_tracks : Int
    let artists : [Artist]
}

