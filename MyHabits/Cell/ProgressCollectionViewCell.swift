//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Alexander on 14.03.2023.
//

import UIKit

struct ProgressCollectionCellConfig {
    let percent: Int
    let progress: Float
}

class ProgressCollectionCell: UICollectionViewCell {
    
//    MARK: - Property
    
    static let reuseId = "ProgressCollectionViewCell"
    
    private let status: UILabel = {
       let status = UILabel()
        status.tintColor = .systemGray
        status.text = "Всё получится!"
        status.font = .footnoteStatus
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
    
    private var percent: UILabel = {
       var status = UILabel()
        status.tintColor = .systemGray
        status.text = "0%"
        status.font = .footnoteStatus
        status.textAlignment = .right
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
    
    private var progressView: UIProgressView = {
        var progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = .purple
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    //    MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        prepareView()
        makeConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Functions
    
    func set(config: ProgressCollectionCellConfig) {
        percent.text = "\(config.percent)%"
        progressView.progress = config.progress
    }
    
    private func prepareView(){
        contentView.addSubview(status)
        contentView.addSubview(percent)
        contentView.addSubview(progressView)
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
    }
    
    private func makeConstraint(){
        
        NSLayoutConstraint.activate([
            
            status.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            status.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
           
            percent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            percent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            percent.leadingAnchor.constraint(equalTo: status.leadingAnchor, constant: 8),
            
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 38),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}