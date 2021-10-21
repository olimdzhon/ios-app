//
//  ServiceTVC.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import Foundation
import UIKit

class ServiceTVC: UITableViewCell {
    var name: String?
    var image: UIImage?
    
    var label: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imageContainer: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9215686275, blue: 0.9333333333, alpha: 1)
        return view
    }()
    
    var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageContainer.addSubview(mainImageView)
        self.addSubview(imageContainer)
        self.addSubview(label)
        
        mainImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
        mainImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        
        imageContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageContainer.widthAnchor.constraint(equalTo: imageContainer.heightAnchor).isActive = true
        imageContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(10)).isActive = true
        imageContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        label.leftAnchor.constraint(equalTo: imageContainer.rightAnchor, constant: CGFloat(10)).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let name = name {
            label.text = name
        }
        
        if let image = image {
            mainImageView.image = image
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
