//
//  MoviePhotoCell.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import UIKit

final class MoviePhotoCell: UICollectionViewCell {
    // MARK: - Visual Components

    private let imageView: RemoteImageView = {
        let iv = RemoteImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

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

    func configure(with photoData: Data) {
        imageView.image = UIImage(data: photoData)
    }

    // MARK: - Private Methods

    private func setupUI() {
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    // MARK: - Constants

    static let cellId = "MoviePhotoCell"
}
