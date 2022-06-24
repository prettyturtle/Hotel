//
//  BookmarkViewController.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import UIKit
import SnapKit

class BookmarkViewController: UIViewController {
    // MARK: - UI Components
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(
            self,
            action: #selector(beginRefreshing(_:)),
            for: .valueChanged
        )
        return refresh
    }()
    private lazy var bookmarkTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 150.0
        tableView.dataSource = self
        tableView.register(
            ItemTableViewCell.self,
            forCellReuseIdentifier: ItemTableViewCell.identifier
        )
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private var bookmarkList = [Bookmark]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAttribute()
        setupLayout()
        
        fetchBookmarkList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBookmarkList()
    }
}

// MARK: - UITableViewDataSource
extension BookmarkViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return bookmarkList.count
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ItemTableViewCell.identifier,
            for: indexPath
        ) as? ItemTableViewCell else { return UITableViewCell() }
        let bookmark = bookmarkList[indexPath.row]
        cell.product = bookmark.product
        cell.setupView(
            product: bookmark.product
            , style: .bookmark,
            bookmarkRegisterDate: bookmark.registerDate
        )
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

// MARK: - ItemTableViewCellDelegate
extension BookmarkViewController: ItemTableViewCellDelegate {
    func didTapBookmarkButton() {
        fetchBookmarkList()
    }
}

// MARK: - Methods
private extension BookmarkViewController {
    func fetchBookmarkList() {
        bookmarkList = UserDefaultsManager().getBookmarkList()
        bookmarkTableView.reloadData()
    }
}

// MARK: - @objc Methods
private extension BookmarkViewController {
    @objc func beginRefreshing(_ control: UIRefreshControl) {
        fetchBookmarkList()
        control.endRefreshing()
    }
    @objc func didTapSortButton() {
        print("didTapSortButton")
    }
}

// MARK: - UI Methods
private extension BookmarkViewController {
    func setupNavigationBar() {
        navigationItem.title = "찜"
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )
        rightBarButton.tintColor = .label
        navigationItem.rightBarButtonItem = rightBarButton
    }
    func setupAttribute() {
        view.backgroundColor = .systemBackground
    }
    func setupLayout() {
        view.addSubview(bookmarkTableView)
        bookmarkTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
