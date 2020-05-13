//
//  EmojiKeyBoard.swift
//  ZXCustomKeyBoard
//
//  Created by apple on 2020/5/13.
//  Copyright © 2020 apple. All rights reserved.
//
import UIKit
class RemoveButton: UIButton {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backgroundColor = .clear
    }
    private let normalColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
    private let activeColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
    
    @objc public var isActive = false{
        didSet{
//            setNeedsDisplay()
            removeLayer.strokeColor = isActive ? activeColor.cgColor : normalColor.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let borderPath = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        UIColor.white.setFill()
        borderPath.fill()
        
        let path = UIBezierPath()
        let width: CGFloat = 22
        let height: CGFloat = 16
        let arrowWidth: CGFloat = 6
        let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        let startPoint = CGPoint(x: center.x-width/2, y: center.y)
        path.move(to: startPoint)
        let leftTopPoint = CGPoint(x: center.x-width/2+arrowWidth, y: center.y-height/2)
        path.addLine(to: leftTopPoint)
        
        let rightTopPoint = CGPoint(x: center.x+width/2, y: center.y-height/2)
        path.addLine(to: rightTopPoint)
        
        let rightBottomPoint = CGPoint(x: center.x+width/2, y: center.y+height/2)
        path.addLine(to: rightBottomPoint)
        let leftBottomPoint = CGPoint(x: center.x-width/2+arrowWidth, y: center.y+height/2)
        path.addLine(to: leftBottomPoint)
        path.close()
        
        let point1 = CGPoint(x: center.x-1, y: center.y-3)
        let point2 = CGPoint(x: center.x+5, y: center.y+3)
        path.move(to: point1)
        path.addLine(to: point2)
        
        let point3 = CGPoint(x: center.x-1, y: center.y+3)
        let point4 = CGPoint(x: center.x+5, y: center.y-3)
        path.move(to: point3)
        path.addLine(to: point4)

        removeLayer.path = path.cgPath
        removeLayer.lineJoin = .round
        removeLayer.lineCap = .round
        removeLayer.lineWidth = 1.5
        removeLayer.strokeColor = isActive ? activeColor.cgColor : normalColor.cgColor
        removeLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(removeLayer)
    }
    private let removeLayer = CAShapeLayer()
}

class EmojiKeyBoard: UIView {
    private let activeColor = UIColor(red: 64/255.0, green: 158/255.0, blue: 255/255.0, alpha: 1)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        addLayout()
    }
    //MARK:- FUNC
    /*public*/
    @objc public func setText(_ text: String){
        isActive = !text.isEmpty
    }
    /*private*/
    private func setUpView(){
        backgroundColor = .init(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        changeButtonsState()
        emojiKeys.append([])
        emojiKeys.append(keys)
        tableView.reloadData()
        sendButton.addTarget(self, action: #selector(sendButtonOnClick(_:)), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonOnClick(_:)), for: .touchUpInside)
        addSubview(tableView)
        addSubview(sendButton)
        addSubview(removeButton)
    }
    
    private func addLayout(){
        NSLayoutConstraint(item: tableView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: tableView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: tableView,
                           attribute: .right,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .right,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: tableView,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .left,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: sendButton,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: bottomSafeHeight == 0 ? -16 : -bottomSafeHeight).isActive = true
        NSLayoutConstraint(item: sendButton,
                           attribute: .right,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .right,
                           multiplier: 1,
                           constant: -11).isActive = true
        NSLayoutConstraint(item: sendButton,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 40).isActive = true
        NSLayoutConstraint(item: sendButton,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 51).isActive = true
        
        NSLayoutConstraint(item: removeButton,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: bottomSafeHeight == 0 ? -16 : -bottomSafeHeight).isActive = true
        NSLayoutConstraint(item: removeButton,
                           attribute: .right,
                           relatedBy: .equal,
                           toItem: sendButton,
                           attribute: .left,
                           multiplier: 1,
                           constant: -6).isActive = true
        NSLayoutConstraint(item: removeButton,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 40).isActive = true
        NSLayoutConstraint(item: removeButton,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 51).isActive = true
    }
    
    @objc private func sendButtonOnClick(_ sender: UIButton){
        keyBoardDelegate?.didTapSend?()
    }
    @objc private func removeButtonOnClick(_ sender: UIButton){
        keyBoardDelegate?.didTapRemove?()
    }
    
    @objc private func changeButtonsState(){
        removeButton.isActive = isActive
        sendButton.isUserInteractionEnabled = isActive
        removeButton.isUserInteractionEnabled = isActive
        guard isActive else {
            sendButton.setTitleColor(.init(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1), for: .normal)
            sendButton.backgroundColor = .white
            return
        }
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.setTitleColor(UIColor(white: 1, alpha: 0.6), for: .highlighted)
        sendButton.backgroundColor = activeColor
    }
    
    //MARK:- Getter Setter
    /*public*/
    @objc public var isActive: Bool = false{
        didSet{
            changeButtonsState()
        }
    }
    @objc public weak var keyBoardDelegate: KeyBoardOperateDelegate?
    /*private*/
    private let cellId = "Cell"
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        return tableView
    }()
    private var emojiKeys = [[String]]()
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame.size = CGSize(width: 51, height: 40)
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.setTitle("发送", for: .normal)
        button.setTitleColor(.init(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    private lazy var removeButton: RemoveButton = {
        let button = RemoveButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame.size = CGSize(width: 51, height: 40)
        button.backgroundColor = .white
        button.setTitleColor(.init(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    
}

extension EmojiKeyBoard: KeyBoardProtocol{
    var keys: [String] {
        var hexs = [String]()
        //128567：face截至,128591：Emoji截至
        for index in 128512...128591{
            let hex = String(format: "%02X", index)
            hexs.append(hex)
        }
        return hexs
    }
    
    var keyBoardType: ZXKeyBoardType{
        get{ return .emoji }
    }
}

extension EmojiKeyBoard: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if emojiKeys.first?.count ?? 0 > 0  {
            if indexPath.section == 0{ return 70 }
        }
        return ceil(CGFloat(keys.count)/7)*52+15+40
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EmojiCollection else { return }
        cell.keyBoardDelegate = keyBoardDelegate
        if emojiKeys.first?.count ?? 0 == 0{
            cell.setKeys(emojiKeys[1])
        }else{
            cell.setKeys(emojiKeys[indexPath.section])
        }
    }
}

extension EmojiKeyBoard: UITableViewDataSource{
    func numberOfRows(inSection section: Int) -> Int {
        if emojiKeys.first?.count ?? 0 == 0{
            return 1
        }
        return emojiKeys.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? EmojiCollection
        cell = cell == nil ? EmojiCollection(style: .default, reuseIdentifier: cellId) : cell
        return cell!
    }
    
}


let bottomSafeHeight: CGFloat = UIScreen.main.bounds.size.height >= 812 ? 34 : 0

