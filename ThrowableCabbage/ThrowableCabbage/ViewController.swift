//
//  ViewController.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 25.10.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private let configuration = ARWorldTrackingConfiguration()
    private var planes = [String:Plane]()
    private var cabbages = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    private func setupScene() {
        self.sceneView.delegate = self
        self.planes = [String:Plane]()
        self.sceneView.showsStatistics = true
        self.sceneView.autoenablesDefaultLighting = true
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        guard let scene = SCNScene(named: "art.scnassets/Cabbage2.scn") else { return }
        self.sceneView.scene = scene
    }

    private func setupSession() {
        let congifuration = ARWorldTrackingConfiguration()
        congifuration.planeDetection = .horizontal
        self.sceneView.session.run(congifuration)
    }
    
    private func getCabbageNode() -> SCNNode {
        guard let node = self.sceneView.scene.rootNode.childNode(withName: "kapusta", recursively: true) else {
            return SCNNode() }
        return node
    }
    
    
    private func setupDebugOptions() {
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.automaticallyUpdatesLighting = true
        self.sceneView.showsStatistics = true
    }

    private func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        let planeWidth = CGFloat(anchor.extent.x)
        let planeHeight = CGFloat(anchor.extent.z)
        
        let planeGeometry = SCNPlane(width: planeWidth, height: planeHeight)
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        //set planeNode from vertical to horizontal
        planeNode.transform = SCNMatrix4MakeRotation(.pi/2, 1, 0, 0)
        return planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        let planeNode = Plane(with: anchor)
        self.planes[anchor.identifier.uuidString] = planeNode
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.planes[anchor.identifier.uuidString]
        guard plane != nil, let anchor = anchor as? ARPlaneAnchor else { return }
        plane?.update(anchor: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        self.planes.removeValue(forKey: anchor.identifier.uuidString)
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self.sceneView)
        let result = self.sceneView.hitTest(tapPoint, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        if result.isEmpty { return }
        let hitResult = result.first
        self.insertGeometry(hitPoint: hitResult)
    }
    
    private func insertGeometry(hitPoint: ARHitTestResult?) {
        guard let hitPoint = hitPoint else { return }
       
        let cabbageNode = self.getCabbageNode()
        cabbageNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        cabbageNode.physicsBody?.mass = 2.0
        cabbageNode.physicsBody?.categoryBitMask = 1 << 1
        
        let insertionYOffset: Float = 0.5
        let xPos = hitPoint.worldTransform.columns.3.x
        let yPos = hitPoint.worldTransform.columns.3.y
        let zPos = hitPoint.worldTransform.columns.3.z
        cabbageNode.position = SCNVector3Make(xPos, yPos + insertionYOffset, zPos)
        
        self.sceneView.scene.rootNode.addChildNode(cabbageNode)
        self.cabbages.append(cabbageNode)
    }
}

