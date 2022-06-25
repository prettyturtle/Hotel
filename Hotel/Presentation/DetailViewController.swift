//
//  DetailViewController.swift
//  Hotel
//
//  Created by yc on 2022/06/25.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        return scrollView
    }()
    private lazy var contentView = UIView()
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemFill
        ImageLoader(urlString: product.description.imagePath).getImage { result in
            switch result {
            case .success(let image):
                imageView.image = image
            case .failure(let error):
                print("error \(error)")
            }
        }
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = product.name
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private lazy var ratingStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Icon.starFill.image
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.text = product.rate.description
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2.0
        stackView.alignment = .bottom
        [
            ratingStarImageView,
            ratingLabel
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = product.description.subject
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let product: Product
    
    // MARK: - Init
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAttribute()
        setupLayout()
    }
}

// MARK: - UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= view.frame.height * 0.2 {
            navigationItem.title = ""
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            navigationItem.title = product.name
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
        }
    }
}

// MARK: - @objc Methods
private extension DetailViewController {
    @objc func didTapBookmarkButton() {
        print("didTapBookmarkButton")
    }
}

// MARK: - UI Methods
private extension DetailViewController {
    func setupNavigationBar() {
        let rightBarButton = UIBarButtonItem(
            image: Icon.heart.image,
            style: .plain,
            target: self,
            action: #selector(didTapBookmarkButton)
        )
        rightBarButton.tintColor = .mainColor
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    func setupAttribute() {
        view.backgroundColor = .systemBackground
    }
    func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalToSuperview()
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [
            productImageView,
            nameLabel,
            ratingStackView,
            descriptionLabel
        ].forEach { contentView.addSubview($0) }
        
        let commonSpacing: CGFloat = 16.0
        
        productImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(commonSpacing)
            $0.top.equalTo(productImageView.snp.bottom).offset(commonSpacing)
            $0.trailing.equalToSuperview().inset(commonSpacing)
        }
        ratingStackView.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(commonSpacing)
        }
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(ratingStackView.snp.bottom).offset(commonSpacing)
            $0.trailing.equalTo(nameLabel.snp.trailing)
            $0.bottom.equalToSuperview().inset(commonSpacing)
        }
    }
}
