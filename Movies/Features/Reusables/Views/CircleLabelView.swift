//
//  CircleLabelView.swift
//  Movies
//
//  Created by Sendo Tjiam on 02/09/23.
//

import UIKit
import SnapKit

final class CircleLabelView: UIView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
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
        addSubview(label)
        label.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
    }
    
    func configure(title: String, textColor: UIColor, bgColor: UIColor, size: Int) {
        label.text = title
        label.textColor = textColor
        backgroundColor = bgColor
        roundCorner(with: CGFloat(size/2))
    }
    
}
