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
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.numberOfLines = 2
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
        button.setImage(Icon.heart.image, for: .normal)
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
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    var product: Product?
    private let userDefaultsManager = UserDefaultsManager()
    weak var delegate: ItemTableViewCellDelegate?
    
    // MARK: - SETUP
    func setupView(
        product: Product,
        style: ItemTableViewCellStyle,
        bookmarkRegisterDate: Date? = nil
    ) {
        setupLayout()
        updateView(product: product)
        
        switch style {
        case .total:
            bookmarkRegisterDateLabel.isHidden = true
        case .bookmark:
            bookmarkRegisterDateLabel.isHidden = false
            bookmarkRegisterDateLabel.text = bookmarkRegisterDate?.toString
        }
    }
}

// MARK: - @objc Methods
private extension ItemTableViewCell {
    @objc func didTapBookmarkButton() {
        print("didTapBookmarkButton")
        guard let product = product else { return }
        if bookmarkButton.currentBackgroundImage == Icon.heart.image {
            bookmarkButton.setBackgroundImage(Icon.heartFill.image, for: .normal)
            let item = Bookmark(product: product, isCheck: true, registerDate: Date.now)
            userDefaultsManager.addBookmark(item: item)
        } else {
            bookmarkButton.setBackgroundImage(Icon.heart.image, for: .normal)
            userDefaultsManager.removeBookmark(item: product)
        }
        delegate?.didTapBookmarkButton()
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
        
        if userDefaultsManager.getBookmarkList().contains(where: { $0.product == product }) {
            bookmarkButton.setBackgroundImage(Icon.heartFill.image, for: .normal)
        } else {
            bookmarkButton.setBackgroundImage(Icon.heart.image, for: .normal)
        }
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
