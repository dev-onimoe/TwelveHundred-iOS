//
//  HeaderCollectionReusableView.swift
//  TwelveHundred
//
//  Created by Mas'ud on 8/24/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
  
    @IBOutlet weak var flashPic : UIImageView!
    @IBOutlet weak var promoPic: UIImageView!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topCollectionView: UICollectionView!
    var imgarr = ["https://www.unsplash.com/photos/_3Q3tsJ01nc/download?force=true","https://www.unsplash.com/photos/dlxLGIy-2VU/download?force=true","https://www.unsplash.com/photos/TPUGbQmyVwE/download?force=true","https://unsplash.com/photos/9MRRM_hV4qA/download?force=true","https://unsplash.com/photos/HbAddptme1Q/download?force=true","https://unsplash.com/photos/wSct4rrBPWc/download?force=true","https://unsplash.com/photos/PKMvkg7vnUo/download?force=true"]
    var timer = Timer()
    var counter = 0
    var imgarrPic : [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIManipulation.centreLabel(text: "Flash Deals", view: flashPic)
        UIManipulation.centreLabel(text: "Promotions", view: promoPic)
        
    }
    
    
    
    
    func configure(){
        if imgarrPic.count == 0{
            loadImage()
        }
        
       
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            self.timer.fire()
            }
        
        topCollectionView.layer.cornerRadius = topCollectionView.frame.height/12
        maleBtn.layer.cornerRadius = 10
        femaleBtn.layer.cornerRadius = 10
        
        flashPic.layer.cornerRadius = promoPic.frame.width/15
        flashPic.clipsToBounds = true
        
        promoPic.layer.cornerRadius = promoPic.frame.width/15
        promoPic.clipsToBounds = true
        
        pageControl.numberOfPages = imgarr.count
        
    }
    
    func loadImage(){
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = true
        config.waitsForConnectivity = true
        let sesh = URLSession(configuration: config)
        
        //self.imgarrPic.removeAll()
        print("list: \(self.imgarrPic.count)")
        print("loop will start")
        for position in 0..<imgarr.count {
            
            let url2 = URL(string: imgarr[position])
            
            let data = sesh.dataTask(with: url2!) {data, _, error in
                
                if data != nil && error == nil {
                    
                    let data3 = data!
                    let image = UIImage(data: data3)!
                    self.imgarrPic.append(image)
                    print("TopCollectionView: position: \(position), images: \(self.imgarrPic.count)")
                }else{
                    if error != nil || data == nil {
                        print(error!.localizedDescription)
                    }
                }
            }
            data.resume()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc func changeImage() {
        if counter < imgarr.count{
            let index = IndexPath.init(item: counter, section: 0)
            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = index.item
            counter = counter + 1
        }else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = index.item
            counter += 1
        }
    }
    
    
}

extension HeaderCollectionReusableView : UICollectionViewDelegate {
    
}

extension HeaderCollectionReusableView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topcell", for: indexPath) as! DatacollectionViewcell
        
        DispatchQueue.main.async {
            
            if self.imgarrPic.count != 0{
                if self.imgarrPic.indices.contains(indexPath.row){
                    cell.cellImage.image = self.imgarrPic[indexPath.row]
                }else{
                    cell.cellImage.image = UIImage(named: "pwPic")
                }
                
            }else{
                cell.cellImage.image = UIImage(named: "pwPic")
            }
        }
        return cell
    }
    
    
}

extension HeaderCollectionReusableView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
            let size = topCollectionView.frame
            return CGSize.init(width: size.width+20, height: size.height)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
            return 0.0
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
            return 0.0
    
    }
}
