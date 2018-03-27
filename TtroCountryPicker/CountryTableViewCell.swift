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
import PayWandModelProtocols

open class CountryTableViewCell: BWSwipeRevealCell {
    public var flagImageView : UIImageView!
    public var nameLabel : UILabel!
    public var originNameLabel : TtroLabel!
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
    
    public static let cellHeight : CGFloat = 80
    public static let elementHeight : CGFloat = 50
    
    func initElements(){
        //backgroundColor = UIColor.TtroColors.white.color
        
        flagImageView = UIImageView()
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(flagImageView)
        flagImageView.easy.layout([
            Height(CountryTableViewCell.elementHeight),
            Width(CountryTableViewCell.elementHeight),
            Left(10).to(contentView, .left),
            CenterY().to(contentView, .centerY)
        ])
        
        flagImageView.layer.masksToBounds = true
        flagImageView.layer.cornerRadius = CountryTableViewCell.elementHeight/2
        flagImageView.contentMode = .scaleAspectFit
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoLabel)
        infoLabel.easy.layout([
            Height(CountryTableViewCell.elementHeight),
            Right(10).to(contentView, .right),
            CenterY().to(contentView, .centerY),
            Width(<=0*0.4).like(contentView)
        ])
        infoLabel.textAlignment = .right
        
        nameLabel = TtroLabel(font: UIFont.TtroPayWandFonts.regular1.font, color: UIColor.black)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        originNameLabel = TtroLabel(font: UIFont.TtroPayWandFonts.light2.font, color: UIColor.black.withAlphaComponent(0.6))
        contentView.addSubview(originNameLabel)
        
        nameLabel.easy.layout([
            Height(30),
            Width(<=0*0.6).like(contentView),
            Left(10).to(flagImageView, .right),
            Right(5).to(infoLabel, .left),
            CenterY().to(contentView, .centerY).when({ [weak self] () -> Bool in
                return self?.originNameLabel.text?.count ?? 0 <= 0
            }),
            Bottom(2.5).to(contentView, .centerY).when({ [weak self] () -> Bool in
                return self?.originNameLabel.text?.count ?? 0 > 0
            })
        ])
        
        originNameLabel.easy.layout([
//            Height(30),
            Width().like(nameLabel),
            Left(10).to(flagImageView, .right),
            //CenterY().to(contentView, .centerY),
            Top(5).to(nameLabel),
            Right(5).to(infoLabel, .left)
            ])
        
        originNameLabel.adjustsFontSizeToFitWidth = true
        revealDirection = .none
        
        selectionStyle = .none
        
        
        //backgroundColor = UIColor.clear
//        contentView.backgroundColor = UIColor.clear
        //backView?.backgroundColor = UIColor.orange
    }
    
    func setData(country: CountryP, infoType : MICountryPicker.InfoType, flag: UIImage?){
        flagImageView.image = flag
        nameLabel.text = country.name
        if (country.name != country.originName){
            originNameLabel.text = country.originName
        } else {
            originNameLabel.text = ""
        }
        nameLabel.easy.reload()
        
        switch infoType {
        case .currency:
            infoLabel.text = country.currency?.title
        case .phoneCode:
            infoLabel.text = country.phoneCode
        case .isoCode:
            infoLabel.text = country.code
        }
    }
}
