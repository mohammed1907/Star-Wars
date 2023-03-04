//
//  FilmResultCell.swift
//  StarWars
//
//  Created by Farghaly on 04/03/2023.
//

import UIKit

class FilmResultCell: UITableViewCell {

    @IBOutlet weak var filmContainer: UIView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var direrctorName: UILabel!
    @IBOutlet weak var producerName: UILabel!
    var filmData: FilmCellModel? {
        didSet {
            movieName.text = filmData?.title
            releaseDate.text = filmData?.releaseDate
            direrctorName.text = "Director: " + (filmData?.director ?? "")
            producerName.text = "Producer: " + (filmData?.producer ?? "")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
