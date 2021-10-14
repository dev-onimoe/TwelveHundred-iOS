//
//  UIManipulation.swift
//  TwelveHundred
//
//  Created by Mas'ud on 8/24/21.
//

import Foundation
import UIKit

class UIManipulation {
    
    static func shadowTopBar(_ topBar: UINavigationBar){
        // Set the prefers title style first
        // since this is how navigation bar bounds gets calculated
        //
        
        topBar.topItem?.title = " 12:00 "

        topBar.isTranslucent = false
        //topBar.tintColor = UIColor.orange

        //topBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //topBar.shadowImage = UIImage()
        topBar.backgroundColor = UIColor.black
        // Make your y position to the max of the uiNavigationBar
        // Height should the cornerRadius height, in your case lets say 20
        let shadowView = UIView(frame: CGRect(x: 0, y: topBar.bounds.maxY-10, width: (topBar.bounds.width), height: 20))
        // Make the backgroundColor of your wish, though I have made it .clear here
        // Since we're dealing it in the shadow layer
        shadowView.backgroundColor = .clear
        topBar.insertSubview(shadowView, at: 1)

        let shadowLayer = CAShapeLayer()
        // While creating UIBezierPath, bottomLeft & right will do the work for you in this case
        // I've removed the extra element from here.
        shadowLayer.path = UIBezierPath(roundedRect: shadowView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath

        shadowLayer.fillColor = UIColor.black.cgColor
        //shadowLayer.shadowColor = UIColor.darkGray.cgColor
        
        shadowLayer.shadowColor = UIColor.white.cgColor
        
        
        shadowLayer.shadowPath = shadowLayer.path
        // This too you can set as per your desired result
        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.shadowRadius = 2
        shadowView.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    static func centreLabel(text: String, view: UIView) {
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width+100 , height: 30))
        label1.textColor = UIColor.white
        label1.font = UIFont.init(name: "Poppins-Bold", size:15 )
        label1.text = text
        view.addSubview(label1)
        label1.center = CGPoint(x: view.frame.width, y: view.frame.height/2)
    }
    
    static func loadImage(loopEnd: Int, strArray: [String], completionHandler:@escaping ([UIImage]) -> Void){
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = true
        config.waitsForConnectivity = true
        let sesh = URLSession(configuration: config)
        var imgarrPic:[UIImage] = []
        
        for position in 0..<loopEnd {
            
            let url2 = URL(string: strArray[position])
            
            let data = sesh.dataTask(with: url2!) {data, _, error in
                
                if data != nil && error == nil {
                    
                    let data3 = data!
                    let image = UIImage(data: data3)!
                    imgarrPic.append(image)
                    print("position: \(position), images: \(imgarrPic.count)")
                    if position == loopEnd - 1 {
                      completionHandler(imgarrPic)
                    }
                }else{
                    if error != nil || data == nil {
                        print(error!.localizedDescription)
                    }
                }
            }
            data.resume()
        }
        
    }
}

class SpinningCircleView : UIActivityIndicatorView {
    
    let spinningcircle = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimating() {
        self.isHidden = false
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {self.transform = CGAffineTransform(rotationAngle: .pi)}, completion: { completed in
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {self.transform = CGAffineTransform(rotationAngle: 0)}, completion: {completed in
                self.startAnimating()
            })
        })
    }
    
    override func stopAnimating() {
        self.isHidden = true
    }
    
    func configure() {
        self.isHidden = true
        frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        let rect = self.bounds
        let path = UIBezierPath(ovalIn: rect)
        
        spinningcircle.path = path.cgPath
        spinningcircle.strokeColor = UIColor.black.cgColor
        spinningcircle.fillColor = UIColor.clear.cgColor
        spinningcircle.lineCap = .round
        spinningcircle.lineWidth = 5
        spinningcircle.strokeEnd = 0.25
        
        self.layer.addSublayer(spinningcircle)
    }
}
