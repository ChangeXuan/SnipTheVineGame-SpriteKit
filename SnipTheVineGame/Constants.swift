//
//  Constants.swift
//  SnipTheVineGame
//
//  Created by 覃子轩 on 2017/5/20.
//  Copyright © 2017年 覃子轩. All rights reserved.
//

import UIKit

/// 图片名称
struct ImageName {
    static let INbackground = "Background"
    static let INground = "Ground"
    static let INwater = "Water"
    static let INvineTexture = "VineTexture"
    static let INvineHolder = "VineHolder"
    static let INcrocMouthClosed = "CrocMouthClosed"
    static let INcrocMouthOpen = "CrocMouthOpen"
    static let INcrocMask = "CrocMask"
    static let INprize = "Pineapple"
    static let INprizeMask = "PineappleMask"
}

/// 音频文件
struct SoundFile {
    static let SFbackgroundMusic = "CheeZeeJungle.caf"
    static let SFslice = "Slice.caf"
    static let SFsplash = "Splash.caf"
    static let SFnomNom = "NomNom.caf"
}

/// 场景图层
struct Layer {
    static let Lbackground: CGFloat = 0
    static let Lcrocodile: CGFloat = 1
    static let Lvine: CGFloat = 1
    static let Lprize: CGFloat = 2
    static let Lforeground: CGFloat = 3
}

/// 物理类别
struct PhysicsCategory {
    static let PCcrocodile: UInt32 = 1
    static let PCvineHolder: UInt32 = 2
    static let PCvine: UInt32 = 4
    static let PCprize: UInt32 = 8
    static let PCWater: UInt32 = 16
}

/// 游戏配置
struct GameConfiguration {
    static let GCvineDataFile = "VineData.plist"
    static let GCcanCutMultipleVinesAtOnce = false
}
