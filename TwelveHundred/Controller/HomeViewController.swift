//
//  HomeViewController.swift
//  TwelveHundred
//
//  Created by Mas'ud on 7/11/21.
//

import UIKit

class HomeViewController: UIViewController{

    
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var OuterScrollView: UIScrollView!
    @IBOutlet weak var flashdealPic: UIImageView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionview: UICollectionView!
    @IBOutlet weak var promoPic: UIImageView!
    private var numberOfItemsInRow = 2
    private var miniumSpacing = 15.0
    private var edgeInsetPadding = 10
    var direction : String?
    var lastcontentoffset = Float(0.0)
    var timer = Timer()
    var counter = 0
    var imgarrPic = [UIImage]()
    var imgarr = ["https://www.unsplash.com/photos/_3Q3tsJ01nc/download?force=true","https://www.unsplash.com/photos/dlxLGIy-2VU/download?force=true","https://www.unsplash.com/photos/TPUGbQmyVwE/download?force=true","https://unsplash.com/photos/9MRRM_hV4qA/download?force=true","https://unsplash.com/photos/HbAddptme1Q/download?force=true","https://unsplash.com/photos/wSct4rrBPWc/download?force=true","https://unsplash.com/photos/PKMvkg7vnUo/download?force=true"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize.init(width: topCollectionView.frame.width-5, height: topCollectionView.frame.height-5)
    
        //topCollectionView.collectionViewLayout = layout
        
        OuterScrollView.alwaysBounceVertical = false
        OuterScrollView.bounces = false
        OuterScrollView.delegate = self
        
    
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        
        
        productCollectionview.delegate = self
        productCollectionview.dataSource = self
        productCollectionview.isScrollEnabled = false
        
        //productCollectionview.collectionViewLayout = UICollectionViewFlowLayout()
        // get the VC's specific nav bar
        
        topCollectionView.layer.cornerRadius = topCollectionView.frame.height/12
        
        let topbar = self.navigationController!.navigationBar
        loadImage()
        
        shadowTopBar(topbar)
        
        flashdealPic.layer.cornerRadius = promoPic.frame.width/15
        flashdealPic.clipsToBounds = true
        
        promoPic.layer.cornerRadius = promoPic.frame.width/15
        promoPic.clipsToBounds = true
        
        pagecontrol.numberOfPages = imgarr.count
        
        /*let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: self.flashdealPic.frame.width+100 , height: 30))
        label1.textColor = UIColor.white
        label1.font = UIFont.init(name: "Poppins-Bold", size:15 )
        label1.text = "Flash Deals"
        flashdealPic.addSubview(label1)
        label1.center = CGPoint(x: flashdealPic.frame.width, y: flashdealPic.frame.height/2)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.promoPic.frame.width+120 , height: 30))
        label2.textColor = UIColor.white
        label2.font = UIFont.init(name: "Poppins-Bold", size:15 )
        label2.text = "Promotions"
        promoPic.addSubview(label2)
        label2.center = CGPoint(x: promoPic.frame.width, y: promoPic.frame.height/2)*/
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            self.timer.fire()
            }
        }
        
    
    @objc func changeImage() {
        if counter < imgarr.count{
            let index = IndexPath.init(item: counter, section: 0)
            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pagecontrol.currentPage = index.item
            counter = counter + 1
        }else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pagecontrol.currentPage = index.item
            counter += 1
        }
    }
    
    
    
    
    
    
    
    
    func loadImage(){
        
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = true
        config.waitsForConnectivity = true
        let sesh = URLSession(configuration: config)
        
        for position in 0...6 {
            
            let url2 = URL(string: imgarr[position])
            
            let data = sesh.dataTask(with: url2!) {data, _, error in
                
                
                if data != nil && error == nil {
                    
                    let data3 = data!
                    let image = UIImage(data: data3)!
                    self.imgarrPic.append(image)
                    
                }else{
                    if error != nil || data == nil {
                        DispatchQueue.main.async {
                            self.view.showToast(toastMessage: error!.localizedDescription, duration: 5)
                        }
                        
                    }
                    
                    
                }
            }
            data.resume()
        }
    
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.showToast(toastMessage: "The number \(String(indexPath.item)) is the current number of the cells", duration: 2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView{
            return imgarr.count
        }else if collectionView == productCollectionview {
            return imgarr.count
        }else {
            return imgarr.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topcell", for: indexPath) as! DatacollectionViewcell
            DispatchQueue.main.async {
                
                if self.imgarrPic.count > indexPath.item{
                    cell.cellImage.image = self.imgarrPic[indexPath.item]
                }else{
                    cell.cellImage.image = UIImage(named: "pwPic")
                }
            }
            
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductsViewCell
            DispatchQueue.main.async {
                
                if self.imgarrPic.count > indexPath.item{
                    cell.cornerRadius()
                    cell.productImage.image = self.imgarrPic[indexPath.item]
                }else{
                    cell.cornerRadius()
                    cell.productImage.image = UIImage(named: "pwPic")
                }
            }
            
            
            return cell
        }
        
    
    
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == topCollectionView{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            let inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            edgeInsetPadding = Int(inset.left + inset.right)
            return inset
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == topCollectionView{
            let size = topCollectionView.frame
            return CGSize.init(width: size.width+20, height: size.height)
        }else {
            /*let screenWidth = UIScreen.main.bounds.size.width
            let width = (Int(screenWidth) - (numberOfItemsInRow - 1) * Int(miniumSpacing) - edgeInsetPadding)/numberOfItemsInRow
            return CGSize.init(width: width, height: width)*/
            let size = productCollectionview.frame
            return CGSize.init(width: size.width+20, height: size.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == topCollectionView{
            return 0.0
        }else {
            return CGFloat(self.miniumSpacing)
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == topCollectionView{
            return 0.0
        }else {
            return CGFloat(self.miniumSpacing)
        }
    }
    
    
}

extension HomeViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //view.showToast(toastMessage:"\(scrollView.contentOffset.y)" , duration: 4)
        //print("content offset is: \(scrollView.contentOffset.y)")
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0{
            direction = "down"
        }else if velocity.y < 0{
            direction = "up"
        }
        
        if scrollView.contentOffset.y == CGFloat(697)  {
            productCollectionview.setContentOffset(CGPoint(x: 0, y: targetContentOffset.pointee.y), animated: true)
        }else if scrollView.contentOffset.y == 0 {
            productCollectionview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }else{
            productCollectionview.setContentOffset(CGPoint(x: 0, y: targetContentOffset.pointee.y), animated: true)
        }
        
    }
    
    
    
}

func shadowTopBar(_ topBar: UINavigationBar){
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
