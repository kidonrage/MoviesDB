//
//  MovieTableViewCell.swift
//  MoviesDB
//
//  Created by Vlad Eliseev on 05.03.2021.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    // MARK: - Private Properties

    private let indicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    private let posterView: RemoteImageView = {
        let imageView = RemoteImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 8
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()

    private lazy var textContentView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), titleLabel, descriptionLabel, dateLabel, UIView()])
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let innerTextContentStackView = UIStackView(arrangedSubviews: [UIView(), textContentView, UIView()])
        innerTextContentStackView.distribution = .equalCentering

        let stackView = UIStackView(arrangedSubviews: [posterView, textContentView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()

    // MARK: - Private Properties

    private var viewModel: MovieCellViewModelProtocol?

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(with viewModel: MovieCellViewModelProtocol?) {
        guard let viewModel = viewModel else {
            posterView.alpha = 0
            titleLabel.alpha = 0
            dateLabel.alpha = 0
            descriptionLabel.alpha = 0
            indicatorView.startAnimating()

            return
        }

        posterView.alpha = 1
        titleLabel.alpha = 1
        dateLabel.alpha = 1
        descriptionLabel.alpha = 1
        titleLabel.text = viewModel.movie.title
        dateLabel.text = viewModel.movie.releaseDate
        descriptionLabel.text = viewModel.movie.overview
        indicatorView.stopAnimating()

        if let posterURL = viewModel.moviePosterURL {
            posterView.loadImageFromUrl(url: posterURL)
        }
    }

    // MARK: - Private Methods

    private func setupUI() {
        contentView.addSubview(contentStackView)
        contentView.addSubview(indicatorView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            indicatorView.centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            indicatorView.centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor),

            posterView.widthAnchor.constraint(equalToConstant: 128),
        ])
    }

    // MARK: - Constants

    static let cellId = "MovieTableViewCell"
}
