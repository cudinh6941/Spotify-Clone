//
//  PlaylistViewController.swift
//  LuyenVoCong
//
//  Created by Dinh Pham Kha on 02/08/2023.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist : Playlist
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    required init(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        APICaller.shared.getPlaylistDetail(for: playlist) {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
    


}
