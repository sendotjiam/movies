//
//  EmptyView.swift
//  Movies
//
//  Created by Sendo Tjiam on 02/09/23.
//

import UIKit
import SnapKit

final class EmptyView: UIView {
    
    private lazy var imageView = {
        let imageView = UIImageView(image: UIImage(named: "empty"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel = {
       let label = UILabel()
        label.text = "Currently you don't have any favorite movies."
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .black.withAlphaComponent(0.6)
        label.textAlignment =  .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        })
        
        titleLabel.snp.makeConstraints({ make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(16)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        })
    }
    
}
