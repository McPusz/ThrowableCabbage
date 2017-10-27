//
//  Plane.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 26.10.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import ARKit
import SceneKit

class Plane: SCNNode {
    
    private var anchor: ARPlaneAnchor?
    private var planeGeometry: SCNPlane?
    
    init(with anchor: ARPlaneAnchor) {
        super.init()
        
        self.anchor = anchor
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let gridMaterial = SCNMaterial()
        let gridImage = #imageLiteral(resourceName: "grid")
        gridMaterial.diffuse.contents = gridImage
        self.planeGeometry?.materials = [gridMaterial]
        
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-.pi/2, 1, 0, 0)
        self.setTextureScale()
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(anchor: ARPlaneAnchor) {
        self.planeGeometry?.width = CGFloat(anchor.extent.x)
        self.planeGeometry?.height = CGFloat(anchor.extent.z)
        
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        self.setTextureScale()
    }
    
    private func setTextureScale() {
        let width = Float(self.planeGeometry?.width ?? 0)
        let height = Float(self.planeGeometry?.height ?? 0)
        
        if let material = self.planeGeometry?.materials.first {
            material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1)
            material.diffuse.wrapS = .repeat
            material.diffuse.wrapT = .repeat
        }
    }
    
}
