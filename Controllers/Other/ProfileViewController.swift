//
//  ProfileViewController.swift
//  LuyenVoCong
//
//  Created by Dinh Pham Kha on 02/08/2023.
//

import UIKit
import SDWebImage
class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    private let tableView : UITableView = {
       let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    private var models = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchProfile()
        title = "Profile"
        view.addSubview(tableView)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile{[weak self]result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    print("Profile Error : \(error.localizedDescription)")
                    self?.failedTogetProfile()
                }
            }
            // Do any additional setup after loading the view.
        }
    }
    private func updateUI(with model : UserProfile) {
        tableView.isHidden = false
        models.append("Full Name: \(model.display_name)")
        models.append("Email Address : \(model.email)")
        models.append("User ID : \(model.id)")
        models.append("Plan : \(model.product)")
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }
    private func createTableHeader(with string : String?){
        guard let urlString = string, let url = URL(string: urlString) else{
            return
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/2))
        let imageSize : CGFloat = headerView.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.layer.cornerRadius = 25
        imageView.contentMode = .scaleAspectFit
     
        imageView.sd_setImage(with: url,completed: nil)
        tableView.tableHeaderView = headerView
    }
    private func failedTogetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "Failed to load Profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
