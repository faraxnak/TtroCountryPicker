//
//  CountryTableViewCell.swift
//  Pods
//
//  Created by Farid on 12/14/16.
//
//

import UIKit
import EasyPeasy
import PayWandBasicElements

open class CountryTableViewCell: BWSwipeRevealCell {
    public var flagImageView : UIImageView!
    public var nameLabel : UILabel!
    public var infoLabel : UILabel!
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //backViewbackgroundColor = UIColor.clear
        initElements()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //backViewbackgroundColor = UIColor.clear
        initElements()
    }
    
    public static let cellHeight : CGFloat = 75
    public static let elementHeight : CGFloat = 50
    
    func initElements(){
        //backgroundColor = UIColor.TtroColors.white.color
        
        flagImageView = UIImageView()
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(flagImageView)
        flagImageView <- [
            Height(CountryTableViewCell.elementHeight),
            Width(CountryTableViewCell.elementHeight),
            Left(10).to(contentView, .left),
            CenterY().to(contentView, .centerY)
        ]
        
        flagImageView.layer.masksToBounds = true
        flagImageView.layer.cornerRadius = CountryTableViewCell.elementHeight/2
        flagImageView.contentMode = .scaleAspectFit
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoLabel)
        infoLabel <- [
            Height(CountryTableViewCell.elementHeight),
            Right(10).to(contentView, .right),
            CenterY().to(contentView, .centerY),
            Width(<=0*0.4).like(contentView)
        ]
        infoLabel.textAlignment = .right
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        nameLabel <- [
            Height(CountryTableViewCell.elementHeight),
            Width(<=0*0.6).like(contentView),
            Left(10).to(flagImageView, .right),
            CenterY().to(contentView, .centerY),
            Right(5).to(infoLabel, .left)
        ]
        
        revealDirection = .none
        
        selectionStyle = .none
        //backgroundColor = UIColor.clear
//        contentView.backgroundColor = UIColor.clear
        //backView?.backgroundColor = UIColor.orange
    }
}
