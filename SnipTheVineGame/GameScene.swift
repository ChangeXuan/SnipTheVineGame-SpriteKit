//
//  GameScene.swift
//  SnipTheVineGame
//
//  Created by 覃子轩 on 2017/5/20.
//  Copyright © 2017年 覃子轩. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    fileprivate var particles: SKEmitterNode?
    fileprivate var crocodile: SKSpriteNode!
    fileprivate var prize: SKSpriteNode!
    
//    fileprivate static var backgroundMusicPlayer: AVAudioPlayer!
//    fileprivate var sliceSoundAction: SKAction!
//    fileprivate var splashSoundAction: SKAction!
//    fileprivate var nomNomSoundAction: SKAction!
    fileprivate var levelOver = false
    
    override func didMove(to view: SKView) {
        setUpPhysics()
        setUpScenery()
        setUpPrize()
        setUpVines()
        setUpCrocodile()
        
        //setUpAudio()
    }
    
}

// MARK: - SetUp
extension GameScene {
    
    /// 初始化场景中的物理世界
    fileprivate func setUpPhysics() {
        
        self.physicsWorld.contactDelegate = self
        // 设置物理世界的重力
        self.physicsWorld.gravity = CGVector.init(dx: 0, dy: -9.8)
        // 设置物理世界的速度
        self.physicsWorld.speed = 1.0
    }
    
    /// 初始化场景
    fileprivate func setUpScenery() {
        // 背景
        let background = SKSpriteNode.init(imageNamed: ImageName.INbackground)
        // anchorPoint使用了unit坐标系，0.0为左下角，1.1为右上角
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        background.position = CGPoint.init(x: 0, y: 0)
        background.zPosition = Layer.Lbackground
        background.size = CGSize.init(width: self.size.width, height: self.size.height)
        self.addChild(background)
        // 前景
        let water = SKSpriteNode.init(imageNamed: ImageName.INwater)
        water.anchorPoint = CGPoint.init(x: 0, y: 0)
        water.position = CGPoint.init(x: 0, y: 0)
        water.zPosition = Layer.Lforeground
        water.size = CGSize.init(width: self.size.width, height: self.size.height*0.2139)
        //water.physicsBody = SKPhysicsBody.init(texture: SKTexture.init(imageNamed: ImageName.INwater), size: water.size)
        //water.physicsBody?.categoryBitMask = PhysicsCategory.PCWater
        //water.physicsBody?.contactTestBitMask = PhysicsCategory.PCprize
        self.addChild(water)
    }
    
    /// 初始化菠萝
    fileprivate func setUpPrize() {
        
        self.prize = SKSpriteNode.init(imageNamed: ImageName.INprize)
        self.prize.position = CGPoint.init(x: self.size.width*0.5, y: self.size.height*0.7)
        self.prize.zPosition = Layer.Lprize
        self.prize.physicsBody = SKPhysicsBody.init(texture: SKTexture.init(imageNamed: ImageName.INprize), size: self.prize.size)
        self.prize.physicsBody?.categoryBitMask = PhysicsCategory.PCprize
        self.prize.physicsBody?.collisionBitMask = 0
        // 设置菠萝的密度为0.5，增加了菠萝的灵活度
        self.prize.physicsBody?.density = 0.5
        self.addChild(self.prize)
    }
    
    /// 初始化菠萝藤数据
    fileprivate func setUpVines() {
        
        let dataFile = Bundle.main.path(forResource: GameConfiguration.GCvineDataFile, ofType: nil)
        let vines = NSArray.init(contentsOfFile: dataFile!) as! [NSDictionary]
        var i = 0
        for vine in vines {
            let length = Int(vine["length"] as! NSNumber)
            let relAnchorPoint = CGPointFromString(vine["relAnchorPoint"] as! String)
            let anchorPoint = CGPoint.init(x: relAnchorPoint.x*self.size.width, y: relAnchorPoint.y*self.size.height)
            let vineNode = VineNode.init(length: length, anchorPoint: anchorPoint, name: "\(i)")
            vineNode.addToScene(self)
            vineNode.attachToPrize(self.prize)
            i += 1
            
        }
        
    }
    
    /// 初始化鳄鱼
    fileprivate func setUpCrocodile() {
        self.crocodile = SKSpriteNode.init(imageNamed: ImageName.INcrocMouthClosed)
        self.crocodile.position = CGPoint.init(x: self.size.width*0.75, y: self.size.height*0.312)
        self.crocodile.zPosition = Layer.Lcrocodile
        self.crocodile.physicsBody = SKPhysicsBody.init(texture: SKTexture.init(imageNamed: ImageName.INcrocMask),
                                                        size: self.crocodile.size)
        self.crocodile.physicsBody?.categoryBitMask = PhysicsCategory.PCcrocodile
        // collision设置为零可以保证不会被碰撞弹开
        self.crocodile.physicsBody?.collisionBitMask = 0
        self.crocodile.physicsBody?.contactTestBitMask = PhysicsCategory.PCprize
        self.crocodile.physicsBody?.isDynamic = false
        
        self.addChild(self.crocodile)
        self.animateCrocodile()
    }
    
    /// 初始化播放器
    fileprivate func setUpAudio() {
        
//        if GameScene.backgroundMusicPlayer == nil {
//            let backgroundMusicURL = Bundle.main.url(forResource: "CheeZeeJungle", withExtension: "caf")
//            
//            do {
//                let theme = try AVAudioPlayer(contentsOf: backgroundMusicURL!)
//                GameScene.backgroundMusicPlayer = theme
//                
//            } catch {
//                // 无法加载文件 :[
//            }
//            
//            GameScene.backgroundMusicPlayer.numberOfLoops = -1
//        }
//        
//        if !GameScene.backgroundMusicPlayer.isPlaying {
//            GameScene.backgroundMusicPlayer.play()
//        }
//        
//        self.sliceSoundAction = SKAction.playSoundFileNamed(SoundFile.SFslice, waitForCompletion: false)
//        self.splashSoundAction = SKAction.playSoundFileNamed(SoundFile.SFsplash, waitForCompletion: false)
//        self.nomNomSoundAction = SKAction.playSoundFileNamed(SoundFile.SFnomNom, waitForCompletion: false)
        
    }
    
}

// MARK: - Delegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if self.levelOver {
            self.levelOver = true
            return
        }
        if (contact.bodyA.node == self.crocodile && contact.bodyB.node == self.prize)
            || (contact.bodyA.node == self.prize && contact.bodyB.node == self.crocodile) {
            
            // 把菠萝缩小出去
            let shrink = SKAction.scale(to: 0, duration: 0.08)
            let removeNode = SKAction.removeFromParent()
            // 构建序列
            let sequence = SKAction.sequence([shrink, removeNode])
            self.prize.run(sequence)
            self.runNomNomAnimationWithDelay(0.15)
            //run(nomNomSoundAction)
            self.switchToNewGameWithTransition(SKTransition.doorway(withDuration: 1.0))
        }
        
    }
    
}

// MARK: - Override
extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if self.levelOver {
            self.levelOver = true
            return
        }
        if self.prize.frame.midY < 0 {
            //run(splashSoundAction)
            self.switchToNewGameWithTransition(SKTransition.doorway(withDuration: 1.0))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let startPoint = touch.location(in: self)
            let endPoint = touch.previousLocation(in: self)
            // 按两点坐标枚举这两点间的场景中所有的物理body
            self.scene?.physicsWorld.enumerateBodies(alongRayStart: startPoint, end: endPoint, using: { (body, point, normal, stop) in
                self.checkIfVineCutWithBody(body)
            })
            self.showMoveParticles(touchPosition: startPoint)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        particles?.removeFromParent()
        particles = nil
    }
    
}

// MARK: - Function
extension GameScene {
    
    /// 鳄鱼的张嘴闭嘴动画
    fileprivate func animateCrocodile() {
        
        let duration = 2.0 + drand48()*2.0
        let open = SKAction.setTexture(SKTexture.init(imageNamed: ImageName.INcrocMouthOpen))
        let wait = SKAction.wait(forDuration: duration)
        let close = SKAction.setTexture(SKTexture.init(imageNamed: ImageName.INcrocMouthClosed))
        // 构建动画序列
        let animatSequence = SKAction.sequence([wait,open,wait,close])
        // repeatForever一直重复动画
        self.crocodile.run(SKAction.repeatForever(animatSequence))
        
    }
    
    /// 咀嚼时间
    ///
    /// - parameter delay:
    fileprivate func runNomNomAnimationWithDelay(_ delay: TimeInterval) {
        
        // 移除鳄鱼之前一直使用的动画
        self.crocodile.removeAllActions()
        
        let closeMouth = SKAction.setTexture(SKTexture.init(imageNamed: ImageName.INcrocMouthClosed))
        let wait = SKAction.wait(forDuration: delay)
        let openMouth = SKAction.setTexture(SKTexture.init(imageNamed: ImageName.INcrocMouthOpen))
        let animatSequence = SKAction.sequence([closeMouth,wait,openMouth,wait,closeMouth])
        self.crocodile.run(animatSequence)
        
    }
    
    fileprivate func showMoveParticles(touchPosition: CGPoint) {
        if particles == nil {
            particles = SKEmitterNode(fileNamed: "Particle.sks")
            particles!.zPosition = 1
            particles!.targetNode = self
            self.addChild(particles!)
        }
        particles!.position = touchPosition
    }
    
    /// 检查手指碰撞的物理body是否是菠萝藤
    ///
    /// - parameter body:
    fileprivate func checkIfVineCutWithBody(_ body: SKPhysicsBody) {
        
        let node = body.node!
        //run(sliceSoundAction)
        if let name = node.name {
            // 从当前场景中删除此node，被删除的节点物理body也会被删除
            node.removeFromParent()
            // 按名字枚举其孩子节点
            self.enumerateChildNodes(withName: name, using: { (node, stop) in
                let fadeAway = SKAction.fadeOut(withDuration: 0.25)
                let removeNode = SKAction.removeFromParent()
                let aniamtSequence = SKAction.sequence([fadeAway,removeNode])
                node.run(aniamtSequence)
            })
            
            //当开始切除藤条时保证鳄鱼时开着嘴的
            self.crocodile.removeAllActions()
            self.crocodile.texture = SKTexture.init(imageNamed: ImageName.INcrocMouthOpen)
            self.animateCrocodile()
        }
        
    }
    
    /// 选择新的关卡
    ///
    /// - parameter transition:
    fileprivate func switchToNewGameWithTransition(_ transition: SKTransition) {
        
        let delay = SKAction.wait(forDuration: 1)
        let sceneChange = SKAction.run { 
            let scene = GameScene(size:self.size)
            self.view?.presentScene(scene, transition: transition)
        }
        
        self.run(SKAction.sequence([delay,sceneChange]))
        
    }
}
