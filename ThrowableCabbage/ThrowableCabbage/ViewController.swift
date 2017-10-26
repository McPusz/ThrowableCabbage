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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    private func setupScene() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        guard let scene = SCNScene(named: "art.scnassets/Cabbage2.obj") else { return }
        sceneView.scene = scene
    }
}
