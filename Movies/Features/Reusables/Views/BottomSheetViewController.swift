//
//  BottomSheetViewController.swift
//  Movies
//
//  Created by Sendo Tjiam on 02/09/23.
//

import UIKit
import SnapKit

enum BottomSheetType {
    case success(body: String), fail(body: String)
}

final class BottomSheetViewController: UIViewController {
    private lazy var bodyLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var okButton = {
        let button = UIButton()
        button.setTitle("Got It!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.roundCorner(with: 10)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var contentStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [imageView, bodyLabel, okButton])
        stackView.axis = .vertical
        stackView.spacing = 14.0
        return stackView
    }()
    
    private lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.addSubview(contentStackView)
        return view
    }()
    
    private let maxDimmedAlpha: CGFloat = 0.6
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    private let defaultHeight: CGFloat = 350
    private let dismissibleHeight: CGFloat = 200
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    private var currentContainerHeight: CGFloat = 300
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func configure(type: BottomSheetType) {
        switch type {
        case let .success(body):
            bodyLabel.text = body
            imageView.image = UIImage(named: "succeed")
        case let .fail(body):
            bodyLabel.text = body
            imageView.image = UIImage(named: "failed")
        }
        
    }
}

extension BottomSheetViewController {
    @objc private func handleCloseAction() {
        animateDismissView()
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
        dimmedView.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        
        containerView.snp.makeConstraints({ make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        
        contentStackView.snp.makeConstraints({ make in
            make.top.equalTo(containerView.snp_topMargin).offset(24)
            make.bottom.equalTo(containerView.snp_bottomMargin).offset(-16)
            make.leading.equalTo(containerView.snp_leadingMargin).offset(16)
            make.trailing.equalTo(containerView.snp_trailingMargin).offset(-16)
        })
        
        imageView.snp.makeConstraints({ make in
            make.height.equalTo(150)
        })
        
        okButton.snp.makeConstraints({ make in
            make.height.equalTo(44)
        })
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    @objc private func didTapButton() {
        animateDismissView()
    }
}

// MARK: Animation
extension BottomSheetViewController {
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.containerViewHeightConstraint?.constant = height
            self?.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.containerViewBottomConstraint?.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self else { return }
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.dimmedView.alpha = 0
        } completion: { [weak self] _ in
            self?.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
}
