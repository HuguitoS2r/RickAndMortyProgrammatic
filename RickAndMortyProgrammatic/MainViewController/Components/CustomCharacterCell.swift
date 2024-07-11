//
//  CustomCharacterCell.swift
//  RickAndMortyProgrammatic
//
//  Created by Hugo Huichalao on 08-07-24.
//

import Foundation
import UIKit

class CustomCharacterCell: UITableViewCell {
    
    let titleLabel: UILabel = {
          let label = UILabel()
          label.font = UIFont.boldSystemFont(ofSize: 16)
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    
    let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "chevron.right")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

     
      
      override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          setupViews()
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
    private func setupViews() {
           contentView.addSubview(titleLabel)
           contentView.addSubview(characterImageView)
           contentView.addSubview(iconImage)
           
           NSLayoutConstraint.activate([
               characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
               characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
               characterImageView.widthAnchor.constraint(equalToConstant: 100),
               characterImageView.heightAnchor.constraint(equalToConstant: 100),
               
               titleLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
               titleLabel.trailingAnchor.constraint(equalTo: iconImage.leadingAnchor, constant: -10),
               titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
               
               iconImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
               iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
               iconImage.widthAnchor.constraint(equalToConstant: 15),
               iconImage.heightAnchor.constraint(equalToConstant: 15)
           ])
       }
      
    func configure(with character: Character) {
            titleLabel.text = character.name
            if let url = URL(string: character.image) {
                characterImageView.loadImage(from: url)
            } else {
                characterImageView.image = UIImage(systemName: "photo")
            }
        }
  }
