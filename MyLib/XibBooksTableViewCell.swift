//
//  XibBooksTableViewCell.swift
//  MyLib
//
//  Created by Aliaksandr Pustahvar on 15.04.23.
//

import UIKit

class XibBooksTableViewCell: UITableViewCell {
    
    let service = ServiceApi()

    @IBOutlet var bookImage: UIImageView!
    
    @IBOutlet var bookAuthor: UILabel!
    @IBOutlet var bookTitle: UILabel!
    
    @IBOutlet var bookYear: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.brown.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(for model: Book) {
        bookTitle.text = model.title
        bookImage.layer.cornerRadius = 8
        guard let author = model.authorName else {
            return bookAuthor.text = "No info"
        }
        bookAuthor.text = author[0]
        guard let year = model.firstPublishYear else {
          return  bookYear.text = "First publish year: no info"
        }
        bookYear.text = "First publish year: \(String(year))"
    }

}
