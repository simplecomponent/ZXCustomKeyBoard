//
//  ZXKeyBoard.swift
//  ZXCustomKeyBoard
//
//  Created by apple on 2020/5/13.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ZXKeyBoard: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK:- FUNC
    /*public*/
    /*private*/
    private func setUpView(){
        
    }
    //MARK:- Getter Setter
    /*public*/
    
    /*private*/
    fileprivate var type: ZXKeyBoardType?
}
extension ZXKeyBoard: KeyBoardProtocol
{
    var keyBoardType: ZXKeyBoardType {
        get {
            return type ?? .emoji
        }
        set { }
    }
    
}
