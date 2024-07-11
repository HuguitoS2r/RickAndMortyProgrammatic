//
//  ViewController.swift
//  RickAndMortyProgrammatic
//
//  Created by Hugo Huichalao on 08-07-24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private let viewModel = CharactersViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func navigateToDetailViewController(with character: Character) {
        let detailViewController = DetailViewController()
        detailViewController.characterId = character.id
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

    
    private func setupTableView() {
        view.addSubview(tableView)

        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: header.frame.size.width - 20, height: 40))
        headerLabel.text = "Rick and Morty Characters"
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

        // TableView setup
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomCharacterCell.self, forCellReuseIdentifier: "CustomCharacterCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.fetchCharacters()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCharacterCell", for: indexPath) as? CustomCharacterCell else {
            return UITableViewCell()
        }
        if let character = viewModel.character(at: indexPath.row) {
            cell.configure(with: character)
        }
        return cell
    }

    // Set the height for the cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Adjust this value to change the cell height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        navigateToDetailViewController(with: character)
    }
    
}
