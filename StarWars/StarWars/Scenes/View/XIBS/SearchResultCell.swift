//
//  SearchResultCell.swift
//  StarWars
//
//  Created by Omar Hassanein on 04/03/2023.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var directorName: UILabel!
    var searchData: FilmSearchCellModel? {
        didSet {
            filmName.text = searchData?.title
            directorName.text = " - \(searchData?.director ?? "")"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
