//
//  BookDetailsViewController.swift
//  MyLib
//
//  Created by Aliaksandr Pustahvar on 16.04.23.
//

import UIKit

class BookDetailsViewController: UIViewController {
    let service = ServiceApi()
    var book: Book!
    
    let imageView = UIImageView()
    let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBrown
        setupScrollView()
        getCoverImage(id: book.coverI)
        loadDetails()
    }
    
    private func setupScrollView() {
        
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.systemBrown
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "book")
        imageView.tintColor = UIColor.brown
        scrollView.addSubview(imageView)
        
        let authorNameLabel = UILabel()
        authorNameLabel.textAlignment = .center
        let author = book.authorName?[0]
        authorNameLabel.text = author == nil ? "No Info" : "\(author!)"
        authorNameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        scrollView.addSubview(authorNameLabel)
        
        let bookTitleLabel = UILabel()
        bookTitleLabel.textAlignment = .center
        bookTitleLabel.numberOfLines = 2
        bookTitleLabel.text = book.title
        bookTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        bookTitleLabel.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(bookTitleLabel)
        
        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.numberOfLines = 0
        let year = book.firstPublishYear
        dateLabel.text = "First publish year:\n \(year == nil ? "no info" : "\(year!)")"
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        scrollView.addSubview(dateLabel)
        
        let rankingLabel = UILabel()
        rankingLabel.textAlignment = .center
        rankingLabel.numberOfLines = 0
        let ranking = book.ratingsAverage
        rankingLabel.text = "Average rating:\n \(ranking == nil ? "no info" : "\(String(format: "%.1f", ranking!))")"
        rankingLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        scrollView.addSubview(rankingLabel)
        
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        scrollView.addSubview(descriptionLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 156),
            imageView.heightAnchor.constraint(equalToConstant: 240)
        ])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorNameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            authorNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 7),
            authorNameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30),
            authorNameLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 30),
            authorNameLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookTitleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            bookTitleLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 4),
            bookTitleLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15),
            bookTitleLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 45),
            bookTitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 5),
            dateLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15),
            dateLabel.widthAnchor.constraint(equalToConstant: 140),
            dateLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        rankingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankingLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 5),
            rankingLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 45),
            rankingLabel.widthAnchor.constraint(equalToConstant: 120),
            rankingLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: rankingLabel.bottomAnchor, constant: 20),
            descriptionLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 40),
        ])
    }
    
    func getCoverImage(id: Int?) {
        if let coverId = book.coverI {
            self.service.getImage(id: coverId) { cover in
                guard let coverImage = cover else { return }
                DispatchQueue.main.async {
                    self.imageView.image = coverImage
                }
            }
        }
    }
    
    func loadDetails() {
        service.getBookDescription(id: book.key) { result in
            guard let result = result else {
                self.service.getBookDescriptionShort(id: self.book.key) { results in
                    guard let result = results else {
                        DispatchQueue.main.async {
                            self.descriptionLabel.text = "No description."
                        }
                        return
                    }
                    guard let bookDescription = result.description else {
                        DispatchQueue.main.async {
                            self.descriptionLabel.text = "No description."
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        self.descriptionLabel.text = bookDescription
                    }
                }
                return
            }
            guard let bookDescription = result.description?.value else {
                DispatchQueue.main.async {
                    self.descriptionLabel.text = "No description."
                }
                return
            }
            DispatchQueue.main.async {
                self.descriptionLabel.text = bookDescription
            }
        }
    }
}

