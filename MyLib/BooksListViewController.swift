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
    var books: [Book] = []
    let spinner = UIActivityIndicatorView()
    var book: Book?
    
    @IBOutlet var booksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSpinner()
        booksTableView.delegate = self
        booksTableView.dataSource = self
        booksTableView.register(UINib(nibName: String(describing: XibBooksTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: XibBooksTableViewCell.self))
        
        loadBooks()
    }
    
    func loadBooks() {
        service.getBooks { result in
            guard let result = result else {
                DispatchQueue.main.async {
                    self.pushErrorAlert()
                }
                return
            }
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
    
    func pushErrorAlert() {
        let alert = UIAlertController(title: "Проблема получения данных.", message: "Проверьте соединение и попробуйте еще раз.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать еще раз", style: .default) { action in
            self.loadBooks()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: spinner.stopAnimating)
        
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
                guard let image = coverImage else { return }
                
                DispatchQueue.main.async {
                    self.imageCache.setObject(image, forKey: coverId as AnyObject)
                    cell.bookImage.image = image
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        book = books[indexPath.row]
        booksTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showBookDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBookDetails" {
            let destination = segue.destination as! BookDetailsViewController
            destination.book = book
        }
    }
}
