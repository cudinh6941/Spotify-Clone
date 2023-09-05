//
//  AlbumDetailsResponse.swift
//  LuyenVoCong
//
//  Created by Dinh Pham Kha on 25/08/2023.
//

import Foundation

struct AlbumDetailResponse : Codable{
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
}
struct TracksResponse: Codable{
    let items: [AudioTrack]
}

