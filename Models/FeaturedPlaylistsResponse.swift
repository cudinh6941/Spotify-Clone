//
//  FeaturedPlaylistsResponse.swift
//  LuyenVoCong
//
//  Created by Dinh Pham Kha on 10/08/2023.
//

import Foundation
struct FeaturePlaylistsResponse : Codable{
    let playlists : PlaylistsResponse?
}
struct PlaylistsResponse : Codable{
    let items : [Playlist]
}

struct User : Codable{
    let display_name : String
    let external_urls : [String : String]
    let id : String
}
