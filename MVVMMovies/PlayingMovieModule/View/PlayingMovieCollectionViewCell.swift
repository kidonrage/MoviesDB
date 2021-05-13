//
//  PlayingMovieCollectionViewCell.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 10.03.2021.
//

import UIKit

final class PlayingMovieCollectionViewCell: UICollectionViewCell {
    // MARK: - Visual Components

    private let posterView: RemoteImageView = {
        let imageView = RemoteImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.alpha = 0.3
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 3
        return label
    }()

    // MARK: - Private Properties

    private var viewModel: PlayingMovieViewModelProtocol? {
        didSet {
            guard let viewModel = viewModel else { return }

            titleLabel.text = viewModel.movie.title

            if let posterURL = viewModel.moviePosterURL {
                posterView.loadImageFromUrl(url: posterURL)
            }
        }
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(withViewModel viewModel: PlayingMovieViewModelProtocol) {
        self.viewModel = viewModel
    }

    // MARK: - Private Methods

    private func setupUI() {
        backgroundColor = .label
        layer.cornerRadius = 8

        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

    // MARK: - Constants

    static let cellId = "PlayingMovieCollectionViewCell"
}
