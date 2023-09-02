//
//  DetailHeaderTableViewCell.swift
//  Movies
//
//  Created by Sendo Tjiam on 02/09/23.
//

import UIKit
import SnapKit
import Kingfisher

protocol DetailHeaderCellDelegate: AnyObject {
    func didTapWebpage()
}

final class DetailHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "DetailHeaderTableViewCell"
    
    private lazy var backdropImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black.withAlphaComponent(0.1)
        return imageView
    }()
    
    private lazy var posterImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.roundCorner(with: 10)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var isAdultView = {
        let view = CircleLabelView()
        view.isHidden = true
        return view
    }()
    
    private lazy var ratingView = {
        let view = CircleLabelView()
        return view
    }()
    
    private lazy var taglineLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.6)
        return label
    }()
    
    private lazy var webpageButton = {
        let button = UIButton()
        button.setTitle("See details", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didTapWebpage), for: .touchUpInside)
        button.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        button.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        return button
    }()
    
    weak var delegate: DetailHeaderCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(model: MovieDetail) {
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(model.backdropPath)")
        let posterUrl = URL(string: "https://image.tmdb.org/t/p/w200/\(model.posterPath)")
        titleLabel.text = "\(model.title)".uppercased()
        backdropImageView.kf.setImage(with: backdropUrl,
                                      options: [
                                        .transition(.fade(0.3)),
                                        .cacheOriginalImage
                                      ])
        posterImageView.kf.setImage(with: posterUrl,
                                    placeholder: UIImage(named: "placeholder-img"),
                                    options: [
                                        .transition(.fade(0.3)),
                                        .cacheOriginalImage
                                    ])
        isAdultView.isHidden = !model.adult
        if model.adult {
            isAdultView.isHidden = false
            isAdultView.configure(title: "18+", textColor: .white, bgColor: .systemRed, size: 50)
        }
        
        let voteAvg = round(model.voteAverage * 100) / 100
        if voteAvg <= 4 {
            ratingView.configure(title: String(voteAvg), textColor: .white, bgColor: .systemRed, size: 50)
        } else if voteAvg < 7.5 {
            ratingView.configure(title: String(voteAvg), textColor: .black, bgColor: .systemYellow, size: 50)
        } else if voteAvg >= 7.5 {
            ratingView.configure(title: String(voteAvg), textColor: .white, bgColor: .systemGreen, size: 50)
        }
        
        taglineLabel.text = model.tagline
    }
    
}

extension DetailHeaderTableViewCell {
    private func setupViews() {
        selectionStyle = .none
        
        [backdropImageView, posterImageView, titleLabel, isAdultView, ratingView, taglineLabel, webpageButton].forEach({ [weak self] view in
            self?.contentView.addSubview(view)
        })
        
        isAdultView.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(50)
            make.width.equalTo(50)
        })
        
        backdropImageView.snp.makeConstraints({ make in
            make.height.equalTo(212)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        
        ratingView.snp.makeConstraints({ make in
            make.centerY.equalTo(backdropImageView.snp_bottomMargin)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
            make.width.equalTo(50)
        })
        
        posterImageView.snp.makeConstraints({ make in
            make.leading.equalTo(16)
            make.top.equalTo(backdropImageView.snp_bottomMargin).offset(-32)
            make.height.equalTo(150).priority(.high)
            make.width.equalTo(100)
            make.bottom.equalToSuperview().offset(-16)
        })
        
        titleLabel.snp.makeConstraints({ make in
            make.leading.equalTo(posterImageView.snp_trailingMargin).offset(16)
            make.top.equalTo(backdropImageView.snp_bottomMargin).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        })
        
        taglineLabel.snp.makeConstraints({ make in
            make.leading.equalTo(posterImageView.snp_trailingMargin).offset(16)
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        })
        
        webpageButton.snp.makeConstraints({ make in
            make.top.equalTo(taglineLabel.snp_bottomMargin).offset(16).priority(.high)
            make.leading.equalTo(posterImageView.snp_trailingMargin).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        })
        
    }
    
    @objc private func didTapWebpage() {
        delegate?.didTapWebpage()
    }
}
