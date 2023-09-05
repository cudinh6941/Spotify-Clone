//
//  APICaller.swift
//  LuyenVoCong
//
//  Created by Dinh Pham Kha on 02/08/2023.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    //private init(){}
    struct Constant {
        static let baseApiURL = "https://api.spotify.com/v1"
    }
    
    enum APIError : Error{
        case faileedToGetData
    }
    
    //MARK: - Albums
    public func getAlbumDetails(for album: Album, completion: @escaping(Result<AlbumDetailResponse,Error>) -> Void){
        createRequest(with: URL(string: Constant.baseApiURL + "/albums/" + album.id
                               ), type: .GET, completion: {request in
            let task = URLSession.shared.dataTask(with: request){data,_,error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AlbumDetailResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        })
    }
    //MARK: - Playlist
    public func getPlaylistDetail(for playlist : Playlist, completion: @escaping(Result<PlaylistDetailResponses,Error>) -> Void){
        createRequest(with: URL(string: Constant.baseApiURL + "/playlists/" + playlist.id
                               ), type: .GET, completion: {request in
            let task = URLSession.shared.dataTask(with: request){data,_,error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do{
                   let result = try JSONDecoder().decode(PlaylistDetailResponses.self, from: data)
                    //print(result)
                    //let result = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                   completion(.success(result))
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        })
    }
    // MARK: - Profile
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile,Error>) -> Void){
        createRequest(with: URL(string: Constant.baseApiURL + "/me"), type: .GET) {baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){data,_,error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    //print(result)
                    completion(.success(result))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: Browse
    public func getNewRelease(completion: @escaping ((Result<NewReleaseResponese, Error>)) -> Void){
        createRequest(with: URL(string: Constant.baseApiURL + "/browse/new-releases?limit=50"), type: .GET) {request in
            let task = URLSession.shared.dataTask(with: request) {data,_,error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(NewReleaseResponese.self, from: data)
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(result)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlayList(completion : @escaping (Result<FeaturePlaylistsResponse,Error>)-> Void){
        createRequest(with: URL(string: Constant.baseApiURL + "/browse/featured-playlists?limit=20"), type: .GET)  {request in
            let task = URLSession.shared.dataTask(with: request){data,_,error in
                guard let data = data, error == nil else {
                    return
                }
                do{
                    let resutl = try JSONDecoder().decode(FeaturePlaylistsResponse.self,from: data)
                    //print(resutl)
                    completion(.success(resutl))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    public func getRecommendations(genres : Set<String>, completion: @escaping((Result<RecommendationsResponse,Error>)-> Void)){
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constant.baseApiURL + "/recommendations?limit=40&seed_genres=\(seeds)"), type: .GET){request in

            let task = URLSession.shared.dataTask(with: request){data,_,error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecommendationsResponse.self,from: data)
                    completion(.success(result))
                    //print(result)
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    public func getRecommededGenres(completion : @escaping ((Result<RecommendedGenresResponse,Error>) -> Void)){
        
        createRequest(with:URL(string: Constant.baseApiURL + "/recommendations/available-genre-seeds"), type: .GET) {request in
           
            let task = URLSession.shared.dataTask(with: request){data,_,error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.faileedToGetData))
                    return
                    
                }
                do{
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    enum HTTPMethod : String{
        case GET
        case POST
    }
    private func createRequest(with url : URL?,type : HTTPMethod, completion: @escaping(URLRequest)->Void) {
        AuthManager.shared.withValidToken{token in
            guard let apiURL = url else{
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 300
            completion(request)
        }
    }
}
