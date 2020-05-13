//
//  EmojiCell.swift
//  ZXCustomKeyBoard
//
//  Created by apple on 2020/5/13.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class EmojiCollection: UITableViewCell {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 34, height: 34)
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.delaysContentTouches = false
        collection.isScrollEnabled = false
        collection.bounces = false
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.register(EmojiItem.self, forCellWithReuseIdentifier: "Cell")
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK:- FUNC
    /*public*/
    @objc public weak var keyBoardDelegate: KeyBoardOperateDelegate?
    public func setKeys(_ keys: [String]){
        _keys = keys
        let height = ceil(CGFloat(keys.count)/7)*52+15+40
        heightConstraint.constant = height
        collectionView.reloadData()
    }
    
    /*private*/
    private func setUpView(){
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(collectionView)
        NSLayoutConstraint(item: collectionView,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .left,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: collectionView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: collectionView,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .width,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        heightConstraint = NSLayoutConstraint(item: collectionView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .height,
                                              multiplier: 1,
                                              constant: 0)
        heightConstraint.isActive = true
        
    }
    private var heightConstraint = NSLayoutConstraint()
    private var _keys = [String]()
}

extension EmojiCollection: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 20, bottom: 40, right: 20)
    }
}

extension EmojiCollection: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        keyBoardDelegate?.didTapKey(_keys[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? EmojiItem else { return }
        cell.label.text = _keys[indexPath.row].emojiValue
    }
}

extension EmojiCollection: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! EmojiItem
        return cell
    }
}

class EmojiItem: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    //MARK:- FUNC
    /*public*/
    /*private*/
    private func setUpView(){
        contentView.addSubview(label)
    }
    //MARK:- Getter Setter
    /*public*/
    /*private*/
    fileprivate var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
}

extension Data{
    var emojiValue: String?{
        get{
            let str = String(data: self, encoding: .utf8)
            return str
        }
    }
}

extension String{
    ///emoji的16进制字符串才可转化成功
    var emojiValue: String?{
        get{
            guard let sixStr = Int(self,radix: 16),
                let scalar = Unicode.Scalar.init(sixStr)
                else { return nil }
            let str = String(Character.init(scalar))
            return str
        }
    }
    
    ///byte数组（utf-8）
    var utf8Bytes: [UInt8]?{
        get{
            guard let data = data(using: .utf8) else {
                return nil
            }
            return [UInt8](data)
        }
    }
    
    
}

extension Array where Element == UInt8{
    var hexString: String{
        let hex =  compactMap({
            String(format: "%02x", $0).uppercased()
        }).joined()
        return hex
    }
}
