//
//  VineNode.swift
//  SnipTheVineGame
//
//  Created by 覃子轩 on 2017/5/20.
//  Copyright © 2017年 覃子轩. All rights reserved.
//

import UIKit
import SpriteKit

class VineNode: SKNode {
    
    private let length: Int
    private let anchorPoint: CGPoint
    private var vineSegments: [SKNode] = []
    
    init(length: Int, anchorPoint: CGPoint, name: String) {
        self.length = length
        self.anchorPoint = anchorPoint
        super.init()
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.length = aDecoder.decodeInteger(forKey: "length")
        self.anchorPoint = aDecoder.decodeCGPoint(forKey: "anchorPoint")
        super.init(coder: aDecoder)
    }
    
    /// 添加vine道场景中
    ///
    /// - parameter scene:
    func addToScene(_ scene: SKScene) {
        
        // 这是当前节点的物理图层
        self.zPosition = Layer.Lvine
        scene.addChild(self)
        
        let vineHolder = SKSpriteNode.init(imageNamed: ImageName.INvineHolder)
        vineHolder.position = self.anchorPoint
        vineHolder.zPosition = 1
        vineHolder.physicsBody = SKPhysicsBody.init(circleOfRadius: vineHolder.size.width/2)
        // 菠萝藤的挂点不需要下落
        vineHolder.physicsBody?.isDynamic = false
        vineHolder.physicsBody?.categoryBitMask = PhysicsCategory.PCvineHolder
        // 菠萝藤的挂点不能被碰撞改变位置
        vineHolder.physicsBody?.collisionBitMask = 0
        
        self.addChild(vineHolder)
        
        // 添加菠萝藤的各个部分
        for i in 0..<length {
            let vineSegment = SKSpriteNode(imageNamed: ImageName.INvineTexture)
            let offset = vineSegment.size.height * CGFloat(i + 1)
            vineSegment.position = CGPoint(x: anchorPoint.x, y: anchorPoint.y - offset)
            vineSegment.name = name
            vineSegment.physicsBody = SKPhysicsBody(rectangleOf: vineSegment.size)
            vineSegment.physicsBody?.categoryBitMask = PhysicsCategory.PCvine
            vineSegment.physicsBody?.collisionBitMask = PhysicsCategory.PCvineHolder
            // 添加进全局数组方便其他函数访问
            self.vineSegments.append(vineSegment)
            self.addChild(vineSegment)
        }
        
        // 添加链接点，这里是菠萝藤的挂点和菠萝藤的第一个节点链接
        let joint = SKPhysicsJointPin.joint(withBodyA: vineHolder.physicsBody!, bodyB: self.vineSegments[0].physicsBody!,
                                            anchor: CGPoint.init(x: vineHolder.frame.midX, y: vineHolder.frame.minY))
        scene.physicsWorld.add(joint)
        
        for i in 1..<length {
            let nodeA = self.vineSegments[i-1]
            let nodeB = self.vineSegments[i]
            // 依次连接菠萝藤的每个节点
            let joint = SKPhysicsJointPin.joint(withBodyA: nodeA.physicsBody!, bodyB: nodeB.physicsBody!,
                                                anchor: CGPoint.init(x: nodeA.frame.midX, y: nodeA.frame.minY))
            scene.physicsWorld.add(joint)
        }
        
    }
    
    /// 链接菠萝
    ///
    /// - parameter prize: 
    func attachToPrize(_ prize: SKSpriteNode) {
        
        let lastNode = self.vineSegments.last
        lastNode?.position = CGPoint.init(x: prize.position.x, y: prize.position.y + prize.size.height*0.1)
        // 每条菠萝藤的最后一个节点和菠萝连接
        let joint = SKPhysicsJointPin.joint(withBodyA: lastNode!.physicsBody!, bodyB: prize.physicsBody!, anchor: lastNode!.position)
        prize.scene?.physicsWorld.add(joint)
        
    }
}
