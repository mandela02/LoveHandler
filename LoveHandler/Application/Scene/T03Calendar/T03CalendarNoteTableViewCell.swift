//
//  T03CalendarNoteTableViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 08/05/2021.
//

import UIKit

class T03CalendarNoteTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with note: Note) {
        titleLabel.text = note.title
        noteLabel.text = note.content
        if let data = note.images.first?.data {
            avatarImageView.image = UIImage(data: data)
        }
    }

}
