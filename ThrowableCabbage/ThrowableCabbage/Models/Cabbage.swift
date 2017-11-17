//
//  Cabbage.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 30.10.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Cabbage: SCNNode {
    static let name = "kapusta"
    
    init(at position: SCNVector3, fromSceneView sceneView: ARSCNView) {
        super.init()
        guard let scene = SCNScene(named: "art.scnassets/Cabbage2.scn") else { return }
        guard let cabbageNode = scene.rootNode.childNode(withName: Cabbage.name, recursively: true) else { return }
        
        let cabbageClone = cabbageNode.clone()
        let cabbageGeometry = cabbageClone.geometry?.copy() as? SCNGeometry
        let cabbageGeometryNode = SCNNode(geometry: cabbageGeometry)
        
        cabbageGeometryNode.position = position
        cabbageGeometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        cabbageGeometryNode.physicsBody?.mass = 2.0
        cabbageGeometryNode.physicsBody?.categoryBitMask = CollisionCategory.cabbage.rawValue
        cabbageGeometryNode.name = Cabbage.name
        
        self.addChildNode(cabbageGeometryNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func remove() {
        self.removeFromParentNode()
    }
}
