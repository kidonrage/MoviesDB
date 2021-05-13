//
//  MovieDetailsViewController.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 05.03.2021.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    // MARK: - Visual Components

    private let posterView: RemoteImageView = {
        let imageView = RemoteImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
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
        let innerPosterView = UIStackView(arrangedSubviews: [UIView(), posterView, UIView()])
        innerPosterView.distribution = .equalCentering

        let stackView = UIStackView(arrangedSubviews: [innerPosterView, titleLabel, dateLabel, descriptionLabel])
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

        setupUI()
        updateUI()
    }

    // MARK: - Private Methods

    private func updateUI() {
        title = viewModel.movie.title

        posterView.image = nil
        titleLabel.text = viewModel.movie.title
        dateLabel.text = viewModel.movie.releaseDate
        descriptionLabel.text = viewModel.movie.overview

        if let posterURL = MVVMMoviesManager.getMoviePosterURL(withPath: viewModel.movie.posterPath ?? "") {
            posterView.loadImageFromUrl(url: posterURL)
        }
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

            posterView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}
