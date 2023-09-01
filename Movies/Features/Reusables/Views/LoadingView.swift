//
//  LoadingView.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit
import SnapKit

final class LoadingView: UIView {
    
    private lazy var activityIndicator = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .white
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    var isLoading = false {
        didSet {
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
    }
}
