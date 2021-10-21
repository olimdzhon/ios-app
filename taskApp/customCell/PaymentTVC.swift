//
//  PaymentTVC.swift
//  taskApp
//
//  Created by Олимджон Садыков on 21.10.2021.
//

import Foundation
import UIKit

class PaymentTVC: UITableViewCell {
    var name: String?
    var image: UIImage?
    var date: String?
    
    var label: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var label2: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
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
        self.addSubview(label2)
        
        mainImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
        mainImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        
        imageContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageContainer.widthAnchor.constraint(equalTo: imageContainer.heightAnchor).isActive = true
        imageContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(20)).isActive = true
        imageContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        label.leftAnchor.constraint(equalTo: imageContainer.rightAnchor, constant: CGFloat(10)).isActive = true
        label.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: CGFloat(5)).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        label2.leftAnchor.constraint(equalTo: imageContainer.rightAnchor, constant: CGFloat(10)).isActive = true
        label2.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: CGFloat(-5)).isActive = true
        label2.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
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
        
        if let date = date {
            label2.text = date
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
