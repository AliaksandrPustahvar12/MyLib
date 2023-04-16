//
//  BooksListViewController.swift
//  MyLib
//
//  Created by Aliaksandr Pustahvar on 15.04.23.
//

import UIKit

class BooksListViewController: UIViewController {
    
    let service = ServiceApi()
    let imageCache = NSCache<AnyObject, UIImage>()

    @IBOutlet var booksTableView: UITableView!
    
    var books: [Book] = []
    let spinner = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSpinner()
        booksTableView.delegate = self
        booksTableView.dataSource = self
        booksTableView.register(UINib(nibName: String(describing: XibBooksTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: XibBooksTableViewCell.self))
        
        service.getBooks { result in
            DispatchQueue.main.async {
                self.books = result.docs
                self.booksTableView.reloadData()
                self.spinner.stopAnimating()
            }
        }
    }
    func setUpSpinner() {
        spinner.center = self.view.center
        spinner.style = .large
        spinner.color = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(spinner)
        spinner.startAnimating()
    }
}

extension BooksListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: XibBooksTableViewCell.self))
        as! XibBooksTableViewCell
        cell.configure(for: books[indexPath.row])
        
        if let coverId  = books[indexPath.row].coverI {
            if let imageFromCache = imageCache.object(forKey: coverId as AnyObject) {
                  cell.bookImage.image = imageFromCache
              }

            self.service.getImage(id: coverId) { coverImage in
                guard let image = coverImage else {
                    cell.bookImage.image = UIImage(systemName: "book")
                    return
                    }
                DispatchQueue.main.async {
                    self.imageCache.setObject(image, forKey: coverId as AnyObject)
                cell.bookImage.image = image
            }
        }
    } else {
           cell.bookImage.image = UIImage(systemName: "book")
        }
        return cell
    }
}
