//
//  GameViewController.swift
//  Elf
//
//  Created by Vlad verba  on 12/24/16.
//  Copyright © 2016 vladverba. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds



class GameViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    
    var interstitalHome = GADInterstitial()

    var intersitialRecievedAd = false
    
    var interGO: GADInterstitial!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()

        bannerView.isHidden = true
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-7575941856999317/7843357989"
        bannerView.rootViewController = self
        bannerView.load(request)
        

        let scene = MainMenu(size: CGSize(width: 1536, height: 2048))
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)

        let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        interstitalHome = GADInterstitial(adUnitID: "ca-app-pub-7575941856999317/4824879186")
        
        let requestInterHome = GADRequest()
        interstitalHome.load(requestInterHome)
        
        
        //        self.interstital = GADInterstitial()
        //        var request = GADRequest()
        //        self.interstital.loadRequest(GADRequest());
        
        DispatchQueue.main.asyncAfter(deadline: delayTime)
        {
            self.showAd()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(showGameOverAd), name: NSNotification.Name(rawValue: "ShowInterAd"), object: nil)

        interGO = GADInterstitial(adUnitID: "ca-app-pub-7575941856999317/4126875182")
        
        let requestGO = GADRequest()
        interGO.load(requestGO)
        
        

        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        // change to false
        bannerView.isHidden = false
    }

    func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!){
    
        bannerView.isHidden = true
        
    }
    

    
    func showAd() {
        if (self.interstitalHome.isReady)
        {
            self.interstitalHome.present(fromRootViewController: self)
        }
    }
    
    func showGameOverAd(){
    
        if(interGO.isReady){
        interGO.present(fromRootViewController: self)
        interGO = createAd()
        }
    
    
    }
    
    func createAd() -> GADInterstitial {
    
        let interGO = GADInterstitial(adUnitID: "ca-app-pub-7575941856999317/4126875182")
        interGO.load(GADRequest())
        return interGO
    
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


}
