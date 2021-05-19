//
//  MovieDetailsViewController.swift
//  MoviesDB
//
//  Created by Vlad Eliseev on 05.03.2021.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    // MARK: - Visual Components

    private lazy var imagesSliderView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MoviePhotoCell.self, forCellWithReuseIdentifier: MoviePhotoCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imagesSliderView, titleLabel, dateLabel, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // MARK: - Private Properties

    private let viewModel: MovieDetailsViewModelProtocol

    // MARK: - Initializers

    init(viewModel: MovieDetailsViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()

        setupUI()
        updateUI()

        viewModel.fetchMovieImages()
    }

    // MARK: - Private Methods

    private func bindViewModel() {
        viewModel.handleMovieImagesUpdate = { [weak self] in
            self?.imagesSliderView.reloadData()
        }
    }

    private func updateUI() {
        title = viewModel.movie.title

        titleLabel.text = viewModel.movie.title
        dateLabel.text = viewModel.movie.releaseDate
        descriptionLabel.text = viewModel.movie.overview
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentStackView)

        let contentLayoutGuide = contentScrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            contentStackView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 8),
            contentStackView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),

            imagesSliderView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movieImagesCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviePhotoCell.cellId,
            for: indexPath
        ) as? MoviePhotoCell
        else {
            return UICollectionViewCell()
        }

        cell.configure(with: viewModel.movieImageData(forImageAt: indexPath))

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MovieDetailsViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
