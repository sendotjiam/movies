//
//  DetailBodyTableViewCell.swift
//  Movies
//
//  Created by Sendo Tjiam on 02/09/23.
//

import UIKit
import SnapKit

final class DetailBodyTableViewCell: UITableViewCell {
    
    static let identifier = "DetailBodyTableViewCell"
    
    private lazy var overviewLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var releaseLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var budgetLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
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
        overviewLabel.text = model.overview
        if let date = model.releaseDate {
            releaseLabel.text = "Release on \(String(describing: date).getDateString(separator: "-"))"
        }
        if model.budget != 0 {
            let budget = "\(model.budget)".toCurrency("en_US")
            budgetLabel.text = "\(model.title) cost around $\(budget)"
        }
    }
}

extension DetailBodyTableViewCell {
    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(releaseLabel)
        contentView.addSubview(budgetLabel)
        contentView.addSubview(overviewLabel)
        releaseLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        })
        overviewLabel.snp.makeConstraints({ make in
            make.top.equalTo(releaseLabel.snp_bottomMargin).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        })
        budgetLabel.snp.makeConstraints({ make in
            make.top.equalTo(overviewLabel.snp_bottomMargin).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        })
    }
}
