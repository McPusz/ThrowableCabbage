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
        self.sceneView.showsStatistics = true
        //lightning
        self.sceneView.autoenablesDefaultLighting = false
        self.sceneView.automaticallyUpdatesLighting = false
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        guard let scene = SCNScene(named: "art.scnassets/Cabbage2.scn") else { return }
        self.sceneView.scene = scene
        self.setupWorldBorder()
    }

    private func setupSession() {
        let congifuration = ARWorldTrackingConfiguration()
        congifuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        self.sceneView.session.run(congifuration)
    }
    
    private func getCabbageNode() -> SCNNode {
        guard let node = self.sceneView.scene.rootNode.childNode(withName: "kapusta", recursively: true) else {
            return SCNNode() }
        node.name = "kapusta"
        return node
    }
    
    
    private func setupDebugOptions() {
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.automaticallyUpdatesLighting = true
        self.sceneView.showsStatistics = true
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
    
    private func setupWorldBorder() {
        let bottomBorderNode = WorldBorder()
        self.sceneView.scene.rootNode.addChildNode(bottomBorderNode)
        self.sceneView.scene.physicsWorld.contactDelegate = self
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

        let insertionYOffset: Float = 0.5
        let xPos = hitPoint.worldTransform.columns.3.x
        let yPos = hitPoint.worldTransform.columns.3.y
        let zPos = hitPoint.worldTransform.columns.3.z
        let position = SCNVector3Make(xPos, yPos + insertionYOffset, zPos)
        let cabbageNode = Cabbage(at: position, fromSceneView: self.sceneView)
        self.cabbages.append(cabbageNode)
        self.sceneView.scene.rootNode.addChildNode(cabbageNode)
    }
}

extension ViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {

        if self.nodeAIsWorld(contact: contact) {
            contact.nodeB.removeFromParentNode()
        } else {
            contact.nodeA.removeFromParentNode()
        }
    }
    
    private func nodeAIsWorld(contact: SCNPhysicsContact) -> Bool {
        guard let bitMaskA = contact.nodeA.physicsBody?.categoryBitMask, let bitMaskB = contact.nodeB.physicsBody?.categoryBitMask else { return false }
        let contactMask = bitMaskA | bitMaskB
        guard contactMask == (CollisionCategory.world.rawValue | CollisionCategory.cabbage.rawValue) else { return false }
        return contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.world.rawValue
    }
}

