//
//  TweetCell.swift
//  Twitter
//
//  Created by Pema Sherpa on 2/21/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate{
    
    optional func tweetCell(tweetCell: TweetCell, didChangeValue value: Bool)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let favoritePressedImage = UIImage(named: "like-action-on.png")! as UIImage
    
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
    
        didSet  {
            
            fullNameLabel.text = tweet.user?.name
            usernameLabel.text = "@\((tweet.user?.screenname)!)"
            tweetLabel.text = tweet.text
            timeLabel.text = "· \((tweet?.timeAgo)!)"
            profileImageView.setImageWithURL((tweet.user?.imageURL)!)
            
            
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        fullNameLabel.preferredMaxLayoutWidth = fullNameLabel.frame.size.width
        favoriteButton.addTarget(self, action: "favoriteValueChanged", forControlEvents:UIControlEvents.TouchUpInside)
        retweetButton.addTarget(self, action: "retweetValueChanged", forControlEvents:UIControlEvents.TouchUpInside)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        fullNameLabel.preferredMaxLayoutWidth = fullNameLabel.frame.size.width
        
    }
    
    func favoriteValueChanged() {
        
        if delegate != nil{
            
            delegate?.tweetCell?(self, didChangeValue: favoriteButton.selected)
            
        }
        
        favoriteButton.selected = true
        
    }
    
    func retweetValueChanged() {
        
        if delegate != nil{
            
            delegate?.tweetCell?(self, didChangeValue: retweetButton.selected)
            
        }
        
        retweetButton.selected = true
        
    }

}
