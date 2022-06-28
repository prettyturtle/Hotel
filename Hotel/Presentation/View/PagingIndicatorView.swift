//
//  PagingIndicatorView.swift
//  Hotel
//
//  Created by yc on 2022/06/27.
//

import UIKit
import SnapKit

class PagingIndicatorView: UIView {
    
    // MARK: - UI Components
    private lazy var pagingButton: UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.addTarget(
            self,
            action: #selector(didTapPagingButton),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    weak var delegate: PagingIndicatorViewDelegate?
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 50.0))
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP
    func setupView() {
        setupLayout()
    }
    
    // MARK: - Methods
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - @objc Methods
private extension PagingIndicatorView {
    @objc func didTapPagingButton() {
        activityIndicatorView.startAnimating()
        delegate?.showMoreItem()
    }
}

// MARK: - UI Methods
private extension PagingIndicatorView {
    func setupLayout() {
        [
            pagingButton,
            activityIndicatorView
        ].forEach { addSubview($0) }
        
        pagingButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        activityIndicatorView.snp.makeConstraints {
            $0.leading.equalTo(pagingButton.snp.trailing)
            $0.centerY.equalTo(pagingButton.snp.centerY)
        }
    }
}
