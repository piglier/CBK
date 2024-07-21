//
//  FriendEmptyView.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//


import UIKit

protocol FriendEmptyViewDelegate: AnyObject {
    func updateEpisode(_ espisode: InterviewEpisode)
}

final class FriendEmptyView: View {
    
    weak var delegate: FriendEmptyViewDelegate?
    
    override func viewDidLoad() {
        
        let friendlyImageView = UIImageView(image: UIImage(named: "img_friends_empty"))
        
        addSubview(friendlyImageView)
        friendlyImageView.translatesAutoresizingMaskIntoConstraints = false
        friendlyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        friendlyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65).isActive = true
        friendlyImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -65).isActive = true
        friendlyImageView.heightAnchor.constraint(equalToConstant: 172).isActive = true
        
        let friendlyTitleLabel = UILabel()
        friendlyTitleLabel.text = "就從加好友開始吧：）"
        friendlyTitleLabel.numberOfLines = 0
        friendlyTitleLabel.font = .medium(size: 21)
        friendlyTitleLabel.textColor = .primaryLabel
        
        addSubview(friendlyTitleLabel)
        friendlyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        friendlyTitleLabel.centerXAnchor.constraint(equalTo: friendlyImageView.centerXAnchor).isActive = true
        friendlyTitleLabel.topAnchor.constraint(equalTo: friendlyImageView.bottomAnchor, constant: 41).isActive = true
        
        let secondaryFriendKindLabel = UILabel()
        secondaryFriendKindLabel.numberOfLines = 0
        secondaryFriendKindLabel.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）"
        secondaryFriendKindLabel.font = .regular(size: 14)
        secondaryFriendKindLabel.textColor = .brownGray
        
        addSubview(secondaryFriendKindLabel)
        secondaryFriendKindLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryFriendKindLabel.centerXAnchor.constraint(equalTo: friendlyTitleLabel.centerXAnchor).isActive = true
        secondaryFriendKindLabel.topAnchor.constraint(equalTo: friendlyTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        let addFriendButton = WrapperView<AddFrienButton>()
        addFriendButton.shadowOffset = CGSize(width: 0, height: 4)
        addFriendButton.shadowColor = UIColor.appleGreen.withAlphaComponent(0.4)
        addFriendButton.shadowRadius = 8
        addFriendButton.shadowOpacity = 1
        addFriendButton.contentView.cornerRadius = 20
        
        addSubview(addFriendButton)
        addFriendButton.translatesAutoresizingMaskIntoConstraints = false
        addFriendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addFriendButton.widthAnchor.constraint(equalToConstant: 192).isActive = true
        addFriendButton.centerXAnchor.constraint(equalTo: secondaryFriendKindLabel.centerXAnchor).isActive = true
        addFriendButton.topAnchor.constraint(equalTo: secondaryFriendKindLabel.bottomAnchor, constant: 25).isActive = true
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addFriendButton.addGestureRecognizer(tapGestureRecognizer)
        
        let accessoryLabel = WrapperView<UILabel>()
        let attribute1 = NSAttributedString(string: "幫助好友更快找到你？", attributes: [.font: UIFont.regular(size: 13), .foregroundColor: UIColor.brownGray])
        let attribute2 = NSAttributedString(
            string: "設定KOKO ID",
            attributes: [
                .font: UIFont.regular(size: 13),
                .underlineColor: UIColor.primaryTintColor,
                .foregroundColor: UIColor.primaryTintColor,
                .underlineStyle: NSUnderlineStyle.thick.rawValue
            ]
        )
        let string = NSMutableAttributedString()
        string.append(attribute1)
        string.append(attribute2)
        accessoryLabel.contentView.attributedText = string
        
        addSubview(accessoryLabel)
        accessoryLabel.translatesAutoresizingMaskIntoConstraints = false
        accessoryLabel.centerXAnchor.constraint(equalTo: addFriendButton.centerXAnchor).isActive = true
        accessoryLabel.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 37).isActive = true

        
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.updateEpisode(InterviewEpisode.episode2)
    }
}

fileprivate final class AddFrienButton: View {
    
    let titleLabel = UILabel()
        .then {
            $0.font = .medium(size: 16)
            $0.text = "加好友"
            $0.textColor = .white
        }
    let iconView = UIImageView(image: UIImage(named: "ic_white_add_friend"))
    let gradient = GradientView()
        .then {
            $0.startPoint = CGPoint(x: 0, y: 0.5)
            $0.endPoint = CGPoint(x: 1, y: 0.5)
            $0.colors = [.frogGreen, .boogerGreen]
        }
    
    override func viewDidLoad() {
        
        addSubview(gradient)
        addSubview(titleLabel)
        addSubview(iconView)
        
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(center: CGPoint(x: bounds.rightCenter.x - 20, y: bounds.rightCenter.y), size: iconView.sizeThatFits(bounds.size))
        titleLabel.frame = CGRect(center: bounds.center, size: titleLabel.sizeThatFits(bounds.size))
        gradient.frame = bounds
    }
}
