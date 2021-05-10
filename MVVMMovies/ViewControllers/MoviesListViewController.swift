//
//  MVVMMoviesListViewController.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 05.03.2021.
//

import UIKit

final class MVVMMoviesListViewController: UITableViewController {
    // MARK: - Visual Components

    private let moviesTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Популярные", "Лучшие отзывы", "Скоро в кино"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        return segmentedControl
    }()

    private lazy var playingMVVMMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 180),
            collectionViewLayout: layout
        )
        collectionView.register(
            PlayingMovieCollectionViewCell.self,
            forCellWithReuseIdentifier: PlayingMovieCollectionViewCell.cellId
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.backgroundColor = .systemBackground

        return collectionView
    }()

    private let playingMVVMMoviesHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Сейчас в кино"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private lazy var playingMVVMMoviesView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 180))

        view.addSubview(playingMVVMMoviesHeaderLabel)
        view.addSubview(playingMVVMMoviesCollectionView)

        view.backgroundColor = .systemBackground

        return view
    }()

    // MARK: - Private Properties

    private let viewModel = MVVMMoviesListViewModel()
    private let movieDetailsVC = MovieDetailsViewController()

    // MARK: - UITableViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "MVVMMovies"

        viewModel.delegate = self

        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellId)

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(viewModel, action: #selector(viewModel.refreshMVVMMovies), for: .valueChanged)

        moviesTypeSegmentedControl.addTarget(self, action: #selector(handleMovieTypeChanged), for: .valueChanged)

        tableView.tableHeaderView = playingMVVMMoviesView
        tableView.prefetchDataSource = self

        viewModel.selectMVVMMoviesType(at: moviesTypeSegmentedControl.selectedSegmentIndex)
        viewModel.refreshMVVMMovies()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        playingMVVMMoviesView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        playingMVVMMoviesHeaderLabel.frame = CGRect(x: 16, y: 0, width: playingMVVMMoviesView.frame.width, height: 30)
        playingMVVMMoviesCollectionView.frame = CGRect(
            x: 0,
            y: 30,
            width: playingMVVMMoviesView.frame.width,
            height: 134
        )
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in _: UITableView) -> Int {
        1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.totalCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.cellId,
            for: indexPath
        )
            as? MovieTableViewCell
        else {
            return UITableViewCell()
        }

        if isLoadingCell(for: indexPath) {
            cell.configure(with: nil)
        } else {
            cell.configure(with: viewModel.movie(at: indexPath.row))
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieDetailsVC.movie = viewModel.movie(at: indexPath.row)

        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }

    override func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        40
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        moviesTypeSegmentedControl.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        return moviesTypeSegmentedControl
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        240
    }

    // MARK: - Private Methods

    @objc private func handleMovieTypeChanged() {
        viewModel.selectMVVMMoviesType(at: moviesTypeSegmentedControl.selectedSegmentIndex)
        viewModel.fetchMVVMMovies()
    }

    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        indexPath.row >= viewModel.currentCount
    }

    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

// MARK: - MVVMMoviesListViewModelDelegate

extension MVVMMoviesListViewController: MVVMMoviesListViewModelDelegate {
    func didFetchMVVMMovies(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            refreshControl?.endRefreshing()
            tableView.reloadData()
            return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }

    func didFetchPlayingMVVMMovies() {
        playingMVVMMoviesCollectionView.reloadData()
    }

    func didFailedFetchingMVVMMovies() {
        let ac = UIAlertController(
            title: "Упс!",
            message: "Что-то поошло не так при загрузке фильмов",
            preferredStyle: .alert
        )

        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(ac, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension MVVMMoviesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.playingMVVMMoviesCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlayingMovieCollectionViewCell.cellId,
            for: indexPath
        ) as? PlayingMovieCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(withMovie: viewModel.playingMovie(at: indexPath.item))

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieDetailsVC.movie = viewModel.playingMovie(at: indexPath.item)

        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MVVMMoviesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width - 32, height: collectionView.frame.height)
    }
}

// MARK: - UICollectionViewDelegate

extension MVVMMoviesListViewController: UICollectionViewDelegate {}

// MARK: - UITableViewDataSourcePrefetching

extension MVVMMoviesListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchMVVMMovies()
        }
    }
}
