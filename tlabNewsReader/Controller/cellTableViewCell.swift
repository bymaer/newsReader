//
//  cellTableViewCell.swift
//  tlabNewsReader
//
//  Created by Artyom Mayorov on 2/3/23.
//

import UIKit

class cellTableViewCell: UITableViewCell {

    
    var cellImage = UIImage()
    var cellTitleLabel = UILabel()
    var cellImageView = UIImageView()
    var cellCountLabel = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        cellCountLabel.textAlignment = .right
        cellCountLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.addSubview(cellCountLabel)
        
        
        cellTitleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        cellTitleLabel.numberOfLines = 0
        self.addSubview(cellTitleLabel)
        
        cellImageView.frame.origin = CGPoint(x: 0, y: 0)
        cellImageView.frame.size = CGSize(width: 128, height: 128)
        cellImageView.contentMode = .scaleToFill
        self.addSubview(cellImageView)
        
    }
    
    override func layoutSubviews() {
        cellTitleLabel.frame = CGRect(x: 138, y: 0, width: (contentView.bounds.width - 138), height: 128)
        cellCountLabel.frame = CGRect(x: 0, y: 110, width: (contentView.frame.size.width-10), height: 18)
    }
    
    
}
