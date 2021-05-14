//
//  MoviesListViewController.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 05.03.2021.
//

import UIKit

final class MoviesListViewController: UITableViewController {
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

    private let viewModel: MoviesListViewModelProtocol

    // MARK: - Public Properties

    var handleGoingToMovieDetails: ((Movie) -> Void)?

    // MARK: - Initializers

    init(viewModel: MoviesListViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UITableViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "MVVMMovies"

        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellId)

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleMoviesRefresh), for: .valueChanged)

        moviesTypeSegmentedControl.addTarget(self, action: #selector(handleMovieTypeChanged), for: .valueChanged)

        tableView.tableHeaderView = playingMVVMMoviesView
        tableView.prefetchDataSource = self
        tableView.showsVerticalScrollIndicator = false

        bindViewModel()

        viewModel.selectMoviesType(at: moviesTypeSegmentedControl.selectedSegmentIndex)
        viewModel.fetchPlayingMovies()
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

    // MARK: - Private Methods

    @objc private func handleMovieTypeChanged() {
        viewModel.selectMoviesType(at: moviesTypeSegmentedControl.selectedSegmentIndex)
        viewModel.fetchMovies()
    }

    @objc private func handleMoviesRefresh() {
        viewModel.refreshMovies()
    }

    private func didFetchMovies(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            refreshControl?.endRefreshing()
            tableView.reloadData()
            return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }

    private func didFetchPlayingMovies() {
        playingMVVMMoviesCollectionView.reloadData()
    }

    private func didFailedFetchingMovies() {
        displayAlert(
            title: "Упс!",
            message: "Что-то поошло не так при загрузке фильмов",
            actions: [UIAlertAction(title: "OK", style: .default, handler: nil)]
        )
    }

    private func bindViewModel() {
        viewModel.didFailedFetchingMoviesHandler = didFailedFetchingMovies
        viewModel.didFetchMoviesHandler = didFetchMovies(with:)
        viewModel.didFetchPlayingMoviesHandler = didFetchPlayingMovies
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

// MARK: - UITableViewDataSource

extension MoviesListViewController {
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
            cell.configure(with: viewModel.movieCellViewModel(forMovieAtIndexPath: indexPath))
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MoviesListViewController {
    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoadingCell(for: indexPath) {
            return
        } else {
            handleGoingToMovieDetails?(viewModel.movie(at: indexPath.row))
        }
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
}

// MARK: - UICollectionViewDataSource

extension MoviesListViewController: UICollectionViewDataSource {
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

        let playingMovieViewModel = viewModel.playingMovieViewViewModel(forMovieAtIndexPath: indexPath)
        cell.configure(withViewModel: playingMovieViewModel)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleGoingToMovieDetails?(viewModel.playingMovie(at: indexPath.row))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width - 32, height: collectionView.frame.height)
    }
}

// MARK: - UICollectionViewDelegate

extension MoviesListViewController: UICollectionViewDelegate {}

// MARK: - UITableViewDataSourcePrefetching

extension MoviesListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchMovies()
        }
    }
}

// MARK: - AlertDisplayer

extension MoviesListViewController: AlertDisplayer {}
