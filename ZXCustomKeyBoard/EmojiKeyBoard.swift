//
//  EmojiKeyBoard.swift
//  ZXCustomKeyBoard
//
//  Created by apple on 2020/5/13.
//  Copyright © 2020 apple. All rights reserved.
//
import UIKit

class HistoryEmoji: NSObject,Codable {
    var list = [String]()
}

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
    
    @objc public func setEmoji(_ emojiValue: String){
        ///删除相同的
        if let index = history.list.firstIndex(where: { $0.elementsEqual(emojiValue) }){
            history.list.remove(at: index)
            history.list.insert(emojiValue, at: 0)
            header.setEmoji(history.list)
            return
        }
        
        ///判断是否超过10个
        if history.list.count >= Int(columns){
            history.list.removeLast()
        }
        history.list.insert(emojiValue, at: 0)
        header.setEmoji(history.list)
    }
    
    @objc public func saveEmoji(){
        EnCode(path: emojiHistoryListPath, type: history) { (result) in
            switch result{
                case .success(_):
                    print("json归档成功!")
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
            }
        }
    }
    
    /*private*/
    private func setUpView(){
        backgroundColor = .init(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        changeButtonsState()
        tableView.reloadData()
        sendButton.addTarget(self, action: #selector(sendButtonOnClick(_:)), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonOnClick(_:)), for: .touchUpInside)
        addSubview(tableView)
        addSubview(sendButton)
        addSubview(removeButton)
        
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        history.list.removeAll()
        if newWindow != nil{
            history = DeCode(path: emojiHistoryListPath, type: HistoryEmoji.self) ?? HistoryEmoji()
            header.setEmoji(history.list)
            tableView.tableHeaderView = history.list.isEmpty ? nil : bg
            tableView.reloadData()
            return
        }
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
                           constant: -15).isActive = true
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
                           constant: -10).isActive = true
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
    private var history = HistoryEmoji()
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
    
    
    lazy var sendButton: UIButton = {
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
    
    lazy var removeButton: RemoveButton = {
        let button = RemoveButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame.size = CGSize(width: 51, height: 40)
        button.backgroundColor = .white
        button.setTitleColor(.init(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    private var collectionHeight: CGFloat = 0{
        didSet{
            tableView.reloadData()
        }
    }
    
    private lazy var bg: UIView = {
        let bg = UIView(frame: CGRect(origin: .zero, size: CGSize(width: KEY_SCREEN_WIDTH, height: 80)))
        header.keyBoardDelegate = keyBoardDelegate
        bg.addSubview(header)
        return bg
    }()
    private var header: EmojiHeader = {
        let head = EmojiHeader()
        return head
    }()
    private var _visibleCells = [UICollectionViewCell]()
    private var _convertFrame = CGRect.zero
    
    private var _cell1 = EmojiCollection()
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
        //        if emojiKeys.first?.count ?? 0 > 0  {
        //            if indexPath.section == 0{ return 70 }
        //        }
        return collectionHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EmojiCollection else { return }
        cell.keyBoardDelegate = keyBoardDelegate
        cell.setKeys(keys)
    }
}

extension EmojiKeyBoard: UITableViewDataSource{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetH = scrollView.contentOffset.y/2
        print("contentOffsetH:\(contentOffsetH)")
        _visibleCells.forEach({
            var frame = $0.convert($0.frame, to: tableView)
            frame.origin = CGPoint(x: frame.origin.x/2, y: frame.origin.y/2-contentOffsetH)
            print("_convertFrame:\(_convertFrame)\ncell frame:\(frame)\nisContain:\(_convertFrame.intersects($0.frame))\n")
            $0.isHidden = _convertFrame.intersects($0.frame)
//            _cell1.reloadData()
            
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? EmojiCollection
        if cell == nil{
            cell = EmojiCollection(style: .default, reuseIdentifier: cellId)
            cell?.heightClosure = {
                [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.collectionHeight = $0
            }
            self.layoutIfNeeded()
            let sendButtonFrame = sendButton.convert(sendButton.frame, to: self)
            let removeButtonFrame = removeButton.convert(removeButton.frame, to: self)
            _convertFrame = CGRect(origin: CGPoint(x: removeButtonFrame.origin.x/2, y: removeButtonFrame.origin.y/2),
                                   size: CGSize(width: sendButtonFrame.origin.x/2+sendButtonFrame.size.width-removeButtonFrame.origin.x/2,
                                                height: sendButtonFrame.size.height))
            //            print("frame:\(frame)")
            //            cell?.setCoverViewFrame(frame,originView: self)
            cell?.getVisibleCells(closure: { [weak self] (cells) in
                guard let weakSelf = self else { return }
                weakSelf._visibleCells = cells
            })
            _cell1 = cell!
        }
        return cell!
    }
    
}

let bottomSafeHeight: CGFloat = UIScreen.main.bounds.size.height >= 812 ? 34 : 0

/// 归档（JSON格式）
/// - Parameters:
///   - path: 保存路径
///   - type: 保存的类
///   - completion: 保存结果回调
func EnCode<T: Codable>(path: String,type: T,completion: ((Result<String,Error>) -> Void)?){
    do{
        let data = try JSONEncoder().encode(type)
        try data.write(to: URL(fileURLWithPath: path))
        completion?(.success("success"))
    }catch{
        completion?(.failure(error))
    }
}

/// 解档(JSON)
/// - Parameters:
///   - path: 路径
///   - type: 类型
/// - Returns: 解档后的实体类
func DeCode<T: Decodable>(path: String,type: T.Type) -> T?{
    guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
        let model = try? JSONDecoder().decode(T.self, from: jsonData)
        else { return nil }
    return model
}

let emojiHistoryListPath = "\(NSHomeDirectory())/Documents/EmojiHistory.json"
