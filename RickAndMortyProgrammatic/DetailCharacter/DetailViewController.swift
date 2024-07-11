//
//  DetailViewController.swift
//  RickAndMortyProgrammatic
//
//  Created by Hugo Huichalao on 10-07-24.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var characterId: Int?
    var character: Character?
    var episodes: [Episode] = []
    private var characterService: CharacterService = APIHandler.shared
    
    private let tableView = UITableView()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let speciesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        if let id = characterId {
            fetchCharacterDetails(id: id)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(nameLabel)
        view.addSubview(characterImageView)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: "EpisodeTableViewCell")
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: header.frame.size.width - 20, height: 40))
        headerLabel.text = "Episodes"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        headerLabel.textColor = .systemGreen
        headerLabel.shadowColor = .yellow
        headerLabel.shadowOffset = CGSize(width: 4, height: 4)
        header.addSubview(headerLabel)
        tableView.tableHeaderView = header
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        let footerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: footer.frame.size.width - 20, height: 20))
        footerLabel.text = "By HuguitoDev"
        footerLabel.textAlignment = .center
        footerLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        footerLabel.textColor = .systemGreen
        footerLabel.shadowColor = .yellow
        footerLabel.shadowOffset = CGSize(width: 4, height: 4)
        footer.addSubview(footerLabel)
        tableView.tableFooterView = footer
        
        let stackView = UIStackView(arrangedSubviews: [
            createTitleValueStackView(title: "Status:", valueLabel: statusLabel),
            createTitleValueStackView(title: "Gender:", valueLabel: genderLabel),
            createTitleValueStackView(title: "Species:", valueLabel: speciesLabel)
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            characterImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            characterImageView.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 100),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor, multiplier: 1.0),
            
            stackView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createTitleValueStackView(title: String, valueLabel: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        return stackView
    }
    
    private func fetchCharacterDetails(id: Int) {
        characterService.fetchCharacterDetails(id: id) { [weak self] result in
            switch result {
            case .success(let character):
                DispatchQueue.main.async {
                    self?.updateUI(with: character)
                }
            case .failure(let error):
                print("Failed to fetch character details: \(error)")
            }
        }
    }
    
    private func updateUI(with character: Character) {
        self.character = character
        nameLabel.text = character.name
        statusLabel.text = character.status
        speciesLabel.text = character.species
        genderLabel.text = character.gender
        if let url = URL(string: character.image) {
            characterImageView.loadImage(from: url)
        }
        fetchEpisodes(from: character.episode)
    }
    
    private func fetchEpisodes(from urls: [String]) {
        characterService.fetchEpisodes(from: urls) { [weak self] result in
            switch result {
            case .success(let episodes):
                self?.episodes = episodes
                self?.tableView.reloadData()
            case .failure(let error):
                print("Failed to fetch episodes: \(error)")
            }
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as? EpisodeTableViewCell else {
            return UITableViewCell()
        }
        
        let episode = episodes[indexPath.row]
        cell.configure(with: episode)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        self.image = UIImage(systemName: "photo")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("No image data found")
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
