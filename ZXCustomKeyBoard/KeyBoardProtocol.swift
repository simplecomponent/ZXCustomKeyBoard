//
//  KeyBoardProtocol.swift
//  ZXCustomKeyBoard
//
//  Created by apple on 2020/5/13.
//  Copyright © 2020 apple. All rights reserved.
//
import Foundation

@objc public protocol KeyBoardProtocol {
    var keyBoardType: ZXKeyBoardType { get }
    var keys: [String] { get }
}

@objc public enum ZXKeyBoardType: Int {
    case emoji
}

///keyboard操作回调代理
@objc public protocol KeyBoardOperateDelegate{
    ///点击按键
    func didTapKey(_ key: String)
    ///点击删除
    @objc optional func didTapRemove()
    ///点击发送
    @objc optional func didTapSend()
}
