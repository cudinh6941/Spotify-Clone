//
//  PlaylistDetailResponses.swift
//  LuyenVoCong
//
//  Created by Dinh Pham Kha on 25/08/2023.
//

import Foundation

struct PlaylistDetailResponses: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
}
struct PlaylistTracksResponse: Codable{
    let items: [PlaylistItem]?
}
struct PlaylistItem: Codable{
    let track: AudioTrack
}
