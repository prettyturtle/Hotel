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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            ItemTableViewCell.self,
            forCellReuseIdentifier: ItemTableViewCell.identifier
        )
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private var bookmarkList = [Bookmark]()
    private let userDefaultsManager = UserDefaultsManager()
    private var sortType: SortType = .registerDescending
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAttribute()
        setupLayout()
        
        fetchBookmarkList(sortType: sortType)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBookmarkList(sortType: sortType)
    }
}

// MARK: - UITableViewDelegate
extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(
            product: bookmarkList[indexPath.row].product
        )
        navigationController?.pushViewController(detailViewController, animated: true)
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
        fetchBookmarkList(sortType: sortType)
    }
}

// MARK: - Methods
private extension BookmarkViewController {
    func fetchBookmarkList(sortType: SortType) {
        var currentBookmarkList = userDefaultsManager.getBookmarkList()
        switch sortType {
        case .registerDescending:
            currentBookmarkList.sort {
                $0.registerDate.compare($1.registerDate) == .orderedDescending
            }
        case .registerAscending:
            currentBookmarkList.sort {
                $0.registerDate.compare($1.registerDate) == .orderedAscending
            }
        case .ratingDescending:
            currentBookmarkList.sort {
                $0.product.rate > $1.product.rate
            }
        case .ratingAscending:
            currentBookmarkList.sort {
                $0.product.rate < $1.product.rate
            }
        }
        bookmarkList = currentBookmarkList
        bookmarkTableView.reloadData()
    }
}

// MARK: - @objc Methods
private extension BookmarkViewController {
    @objc func beginRefreshing(_ control: UIRefreshControl) {
        fetchBookmarkList(sortType: sortType)
        control.endRefreshing()
    }
    @objc func didTapSortButton() {
        let alertController = UIAlertController(
            title: "정렬 기준 선택",
            message: nil,
            preferredStyle: .actionSheet
        )
        _ = SortType.allCases.map { type in
            let action = UIAlertAction(
                title: type.title,
                style: .default
            ) { [weak self] _ in
                guard let self = self else { return }
                self.sortType = type
                self.fetchBookmarkList(sortType: self.sortType)
            }
            if sortType == type {
                action.setValue(UIColor.secondaryLabel, forKey: "titleTextColor")
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

// MARK: - UI Methods
private extension BookmarkViewController {
    func setupNavigationBar() {
        navigationItem.title = "찜"
        let rightBarButton = UIBarButtonItem(
            image: Icon.arrowUpDown.image,
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
