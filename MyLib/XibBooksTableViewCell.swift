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
    
    override func prepareForReuse() {
        bookImage.image = nil
        bookAuthor.text = ""
        bookTitle.text = ""
        bookYear.text = ""
    }
    
    func configure(for model: Book) {
        bookTitle.text = model.title
        bookImage.layer.cornerRadius = 8
        bookImage.image = UIImage(systemName: "book")
        let author = model.authorName?[0]
        bookAuthor.text = author == nil ? "No Info" : "\(author!)"
        let year = model.firstPublishYear
        bookYear.text = "First publish year: \(year == nil ? "no info" : "\(year!)")"
    }
}
