//
//  ItemTableViewCell.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import UIKit
import SnapKit

class ItemTableViewCell: UITableViewCell {
    static let identifier = "ItemTableViewCell"
    
    // MARK: - UI Components
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    private lazy var ratingStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "9.4"
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
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(
            self,
            action: #selector(didTapBookmarkButton),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var bookmarkRegisterDateLabel: UILabel = {
        let label = UILabel()
        label.text = "22.06.24(금) 15:17에 등록"
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - SETUP
    func setupView(product: Product, style: ItemTableViewCellStyle) {
        setupLayout()
        
        updateView(product: product)
        
        switch style {
        case .total:
            bookmarkRegisterDateLabel.isHidden = true
        case .bookmark:
            bookmarkRegisterDateLabel.isHidden = false
        }
    }
}

// MARK: - @objc Methods
private extension ItemTableViewCell {
    @objc func didTapBookmarkButton() {
        print("didTapBookmarkButton")
    }
}

// MARK: - UI Methods
private extension ItemTableViewCell {
    func updateView(product: Product) {
        ImageLoader(urlString: product.thumbnail).getImage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.thumbnailImageView.image = image
            case .failure(let error):
                print("ERROR \(error.localizedDescription)")
            }
        }
        titleLabel.text = product.name
        ratingLabel.text = product.rate.description
    }
    func setupLayout() {
        [
            thumbnailImageView,
            titleLabel,
            ratingStackView,
            bookmarkButton,
            bookmarkRegisterDateLabel
        ].forEach { contentView.addSubview($0) }
        
        let commonSpacing: CGFloat = 16.0
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(commonSpacing)
            $0.top.equalToSuperview().inset(commonSpacing)
            $0.bottom.equalToSuperview().inset(commonSpacing)
            $0.width.equalTo(thumbnailImageView.snp.height)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(commonSpacing)
            $0.top.equalTo(thumbnailImageView.snp.top).inset(4.0)
            $0.trailing.equalToSuperview().inset(commonSpacing)
        }
        ratingStackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(thumbnailImageView.snp.bottom).inset(4.0)
        }
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(commonSpacing)
            $0.bottom.equalTo(ratingStackView.snp.bottom)
            $0.size.equalTo(32.0)
        }
        bookmarkRegisterDateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(commonSpacing)
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.trailing.equalToSuperview().inset(commonSpacing)
            $0.bottom.equalToSuperview()
        }
    }
}
