//
//  HeaderViewCell.swift
//  SwiftimeUI
//
//  Created by Wladmir Edmar Silva Junior on 18/04/20.
//  Copyright © 2020 Wladmir Júnior. All rights reserved.
//

import Foundation
import UIKit

public class HeaderViewCell: UIView {
    
    // MARK: - UI
    
    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    // MARK: - INITIALIZERS
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: - PRIVATE
    
    func setup() {
        buildViewHierarchy()
        addConstraints()
    }
    private func buildViewHierarchy() {
        addSubview(contentView)
        contentView.addSubview(titleLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            contentView.bottomAnchor.constraint(equalTo: topAnchor, constant: -4),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -4),
        ])
    }
}
