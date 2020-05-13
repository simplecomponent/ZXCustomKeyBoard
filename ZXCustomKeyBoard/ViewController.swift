//
//  ViewController.swift
//  ZXCustomKeyBoard
//
//  Created by apple on 2020/5/13.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
class MyTextField: UITextField {
    var resignClosure: (() -> Void)?
    @discardableResult
    override func resignFirstResponder() -> Bool {
        resignClosure?()
        return super.resignFirstResponder()
    }
}

class ViewController: UIViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(inputTextField)
        inputTextField.resignClosure = {
            [weak self] in
            guard let weakSelf = self else { return }
            let image = UIImage(named: "home_comment_emoji")
            weakSelf.emojiButton.setImage(image, for: .normal)
        }
        NSLayoutConstraint(item: inputTextField,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .left,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: inputTextField,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: -100).isActive = true
        
        NSLayoutConstraint(item: inputTextField,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .width,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: inputTextField,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 49).isActive = true
        
    }
    
    private lazy var collectionView: EmojiKeyBoard = {
        let collection = EmojiKeyBoard()
        collection.frame.size.height = 280+bottomSafeHeight
        collection.keyBoardDelegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let emojiButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
    private lazy var inputTextField: MyTextField = {
        let textField = MyTextField()
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.placeholder = "留下你的精彩评论吧"
        let rightBG = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 39, height: 24)))
        emojiButton.setImage(UIImage(named: "home_comment_emoji"), for: .normal)
        emojiButton.contentHorizontalAlignment = .left
        emojiButton.addTarget(self, action: #selector(changeKeyBoardType(_:)), for: .touchUpInside)
        rightBG.addSubview(emojiButton)
        let leftBG = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 49)))
        textField.leftView = leftBG
        textField.leftViewMode = .always
        textField.rightView = rightBG
        textField.rightViewMode = .always
        return textField
    }()
    
    @objc private func textFieldEditingChanged(_ sender: UITextField){
        collectionView.setText(sender.text ?? "")
    }
    
    @objc private func changeKeyBoardType(_ sender: UIButton){
        if !inputTextField.isFirstResponder{
            inputTextField.becomeFirstResponder()
        }
        sender.isSelected = !sender.isSelected
        let image = UIImage(named: sender.isSelected ? "home_comment_keyboard" : "home_comment_emoji")
        sender.setImage(image, for: .normal)
        if sender.isSelected{
            inputTextField.inputView = collectionView
        }else{
            inputTextField.inputView = nil
        }
        inputTextField.reloadInputViews()
    }
    
}

extension ViewController: KeyBoardOperateDelegate{
    func didTapKey(_ key: String) {
        print("hex key: \(key)")
        print("hex to emoji: \(key.emojiValue ?? "")")
        if let data = key.emojiValue?.utf8Bytes{
            print("Int value: \(Int(data.hexString,radix: 10) ?? 0)")
            print(data.compactMap({ String(format: "%02x", $0).uppercased() }))
            let emoji = Data(data).emojiValue ?? ""
            print("data to emoji: \(emoji)")
        }
        inputTextField.text?.append(key.emojiValue ?? "")
        collectionView.setText(inputTextField.text ?? "")
//        print("taped key Value: \(key.emojiStringValue ?? "")")
    }
    
    func didTapRemove() {
        
        let text = inputTextField.text ?? ""
        let count = text.count
        
        if count == 0 {
            collectionView.setText("")
            return
        }
        
        
        
        collectionView.setText(inputTextField.text ?? "")
    }
}



