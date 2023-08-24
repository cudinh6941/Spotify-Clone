//
//  ViewController.swift
//  LuyenVoCong
//
//  Created by Dinh Pham Kha on 19/06/2023.
//

import UIKit
enum BrowseSectionType {
    case newReleases(viewModels: [NewRealeasesCellViewModel])
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModels: [RecommendedTrackCellViewModel])
}
class HomeViewController: UIViewController {
    
    private var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout:  UICollectionViewCompositionalLayout{sectionIndex, _ -> NSCollectionLayoutSection? in
        return HomeViewController.createSectionLayout(section: sectionIndex)
    })
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    private var sections = [BrowseSectionType]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .done, target: self, action: #selector(didTapSettings))
        
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewRealeaseCollectionViewCell.self, forCellWithReuseIdentifier: NewRealeaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommededTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommededTrackCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    private static func createSectionLayout(section : Int) -> NSCollectionLayoutSection{
        switch section{
        case 0:  //Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0) ))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390 / 3)), repeatingSubitem: item, count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390)), repeatingSubitem: verticalGroup, count: 1)
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case 1 :
            //Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200) ))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize:  NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)), repeatingSubitem: item, count: 2)
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:  NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)), repeatingSubitem: verticalGroup, count: 1)
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case 2 :
            //Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0) ))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)), repeatingSubitem: item, count: 1)
            //Section
            let section = NSCollectionLayoutSection(group: group)
            return section
        default :
            //Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0) ))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Group
            let group = NSCollectionLayoutGroup.vertical(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390 / 3)), repeatingSubitem: item, count: 1)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    }
    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newRelease: NewReleaseResponese?
        var featuredPlaylist: FeaturePlaylistsResponse?
        var recommendations: RecommendationsResponse?
        //New Releases
        APICaller.shared.getNewRelease{result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model) :
                newRelease = model
            case .failure(let error) :
                print(error.localizedDescription )
            }
        }
        
        // Featured Playlists
        APICaller.shared.getFeaturedPlayList{result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //Recommend Tracks
        APICaller.shared.getRecommededGenres{result in
            switch result{
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds){recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult{
                    case .success(let model) :
                        recommendations = model
                    case .failure(let error) :
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error): break
                
            }
        }
        group.notify(queue: .main) {
            guard let newAlbums = newRelease?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks else{
                return
            }
            self.configureModel(newAlbums:newAlbums , playlists: playlists, tracks: tracks)
        }
        // Configure model
      
    }
    private func configureModel(newAlbums: [Album], playlists: [Playlist] ,tracks: [AudioTrack]){
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewRealeasesCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "-")
        })))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""),creatorName: $0.owner.display_name)
        })))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendedTrackCellViewModel(name: $0.name, artistName: $0.artists.first?.name ?? "-",artworkURL: URL(string: $0.album.images.first?.url ?? ""))
        })))
        collectionView.reloadData()
    }
   
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type{
        case .newReleases(viewModels: let viewModels):
            return viewModels.count
        case .featuredPlaylists(viewModels: let viewModels):
            return viewModels.count
        case .recommendedTracks(viewModels: let viewModels) :
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type{
        case .newReleases(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewRealeaseCollectionViewCell.identifier, for: indexPath)
                    as? NewRealeaseCollectionViewCell else{
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featuredPlaylists(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath)
                    as? FeaturedPlaylistCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])

            return cell
        case .recommendedTracks(viewModels: let viewModels) :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommededTrackCollectionViewCell.identifier, for: indexPath)
                    as? RecommededTrackCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])

            return cell
        }

    }
    
    
}
