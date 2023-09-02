//
//  DetailViewController.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SafariServices

final class DetailViewController: UIViewController {
    
    private enum DetailSectionType {
        case header, body
    }
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var loadingIndicatorView = {
        let view = LoadingView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.isHidden = true
        view.roundCorner(with: 10)
        return view
    }()
    
    private lazy var favoriteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.roundCorner(with: 25)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        return button
    }()
    
    private let sections : [DetailSectionType] = [
        .header, .body
    ]
    
    private let wireframe = DetailWireframe()
    private let viewModel: DetailViewModelProtocol
    private let bag = DisposeBag()
    
    var isFromFavorite = false
    
    init(with viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
        viewModel.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
}

extension DetailViewController {
    private func setupViews() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DetailHeaderTableViewCell.self, forCellReuseIdentifier: DetailHeaderTableViewCell.identifier)
        tableView.register(DetailBodyTableViewCell.self, forCellReuseIdentifier: DetailBodyTableViewCell.identifier)
        
        view.addSubview(loadingIndicatorView)
        view.addSubview(tableView)
        view.addSubview(favoriteButton)
        
        loadingIndicatorView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
        })
        
        tableView.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        favoriteButton.snp.makeConstraints({ make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(50)
            make.width.equalTo(50)
        })
        
        favoriteButton.isHidden = isFromFavorite
    }
    
    private func setupBindings() {
        viewModel.addFavoriteSubject
            .subscribe({ [weak self] event in
                guard let self else { return }
                switch event {
                case .next(_):
                    self.wireframe.showBottomSheet(from: self, type: .success(body: "You have successfully added this movie to your favorite list."))
                case .error(let error):
                    guard let error = error as? BaseErrors else {
                        return
                    }
                    switch (error) {
                    default:
                        self.wireframe.showBottomSheet(from: self, type: .fail(body: "Failed to add this movie as favorite, please check your favorite list whether this movie has been added before."))
                    }
                case .completed:
                    return
                }
            }).disposed(by: bag)
        
        viewModel.movieDetailSubject
            .subscribe({ [weak self] event in
                guard let self else { return }
                switch event {
                case .next(_):
                    self.tableView.reload()
                case .error(let error):
                    guard let error = error as? BaseErrors else {
                        return
                    }
                    switch (error) {
                    default:
                        self.wireframe.showAlert(from: self, title: "Failed", body: "Failed to get this movie detail, please try again later.", handler: { _ in
                            self.dismiss(animated: true)
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                case .completed:
                    return
                }
            }).disposed(by: bag)
        
        viewModel.loadingSubject
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] isLoading in
                guard let self else { return }
                self.loadingIndicatorView.isLoading = isLoading
                self.loadingIndicatorView.isHidden = !isLoading
                self.view.isUserInteractionEnabled = !isLoading
            })
            .disposed(by: bag)
    }
    
    func openSafariVC(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    @objc private func didTapFavorite() {
        viewModel.addToFavorite()
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailHeaderTableViewCell.identifier, for: indexPath) as? DetailHeaderTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            if let model = viewModel.displayData {
                cell.configure(model: model)
            }
            return cell
        case .body:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailBodyTableViewCell.identifier, for: indexPath) as? DetailBodyTableViewCell else {
                return UITableViewCell()
            }
            if let model = viewModel.displayData {
                cell.configure(model: model)
            }
            return cell
        }
    }
}

extension DetailViewController: DetailHeaderCellDelegate {
    func didTapWebpage() {
        guard let urlString = viewModel.displayData?.homepage,
              let url = URL(string: urlString)
        else { return }
        openSafariVC(url : url)
    }
}

extension DetailViewController : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
