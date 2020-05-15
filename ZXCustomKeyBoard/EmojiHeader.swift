//
//  EmojiHeader.swift
//  ZXCustomKeyBoard
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
let KEY_SCREEN_WIDTH = UIScreen.main.bounds.size.width
let KEY_SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let columns = floor((KEY_SCREEN_WIDTH-40+10)/(34+10))

class EmojiHeader: UICollectionView {
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        let spacingAll = (KEY_SCREEN_WIDTH-40).truncatingRemainder(dividingBy: 34)
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 34, height: 34)
        layout.scrollDirection = .vertical
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: 80)),
                  collectionViewLayout: layout)
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame,collectionViewLayout: layout)
        setUpView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK:- FUNC
    /*public*/
    func setEmoji(_ list: [String]){
        _list = list
        reloadData()
    }
    /*private*/
    private func setUpView(){
        backgroundColor = .clear
        delegate = self
        dataSource = self
        isScrollEnabled = false
        register(EmojiItem.self, forCellWithReuseIdentifier: "Cell")
        
        addSubview(titleLabel)
        
        NSLayoutConstraint(item: titleLabel,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .left,
                           multiplier: 1,
                           constant: 20).isActive = true
        
        NSLayoutConstraint(item: titleLabel,
                           attribute: .right,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .right,
                           multiplier: 1,
                           constant: -20).isActive = true
        
        NSLayoutConstraint(item: titleLabel,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: titleLabel,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 46).isActive = true
    }
    //MARK:- Getter Setter
    /*public*/
    weak var keyBoardDelegate: KeyBoardOperateDelegate?
    /*private*/
    private var _list = [String]()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "最近使用"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
}

extension EmojiHeader: KeyBoardProtocol{
    var keyBoardType: ZXKeyBoardType {
        .emoji
    }
    var keys: [String] {
        return _list
    }
}

extension EmojiHeader: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 46, left: 20, bottom: 0, right: 20)
    }
}

extension EmojiHeader: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        keyBoardDelegate?.didTapKey(keys[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? EmojiItem else { return }
        cell.label.text = keys[indexPath.row].emojiValue
    }
}

extension EmojiHeader: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! EmojiItem
        return cell
    }
}
