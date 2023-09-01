//
//  LoadingCollectionViewCell.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit
import SnapKit

final class LoadingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LoadingCollectionViewCell"
    
    private lazy var indicatorView : UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .medium
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        indicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.indicatorView.stopAnimating()
        }
    }
}

extension LoadingCollectionViewCell {
    private func setupViews() {
        contentView.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        })
    }
}
