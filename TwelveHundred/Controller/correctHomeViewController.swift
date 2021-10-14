//
//  HomeViewController.swift
//  TwelveHundred
//
//  Created by Mas'ud on 7/11/21.
//

import UIKit
import Firebase

class correctHomeViewController: UIViewController {

    @IBOutlet weak var productCollectionview: UICollectionView!
    private var miniumSpacing = 15.0
    private var edgeInsetPadding = 10
    var products:[Products] = []
    var pImgListsArray:[[UIImage]] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getProducts(completion:{prdts in
            self.products = prdts
            if prdts.count != 0{
                for pdt in prdts{
                    self.loadImage2(loopEnd: pdt.Imageurllist.count, strArray: pdt.Imageurllist, completionHandler: ({imgList in
                        self.pImgListsArray.append(imgList)
                    }))
                }
            }
            DispatchQueue.main.async {
                self.productCollectionview.reloadData()
                self.productCollectionview.performBatchUpdates({ [weak self] in
                        let visibleItems = self?.productCollectionview.indexPathsForVisibleItems ?? []
                        self?.productCollectionview.reloadItems(at: visibleItems)
                    }, completion: { (_) in
                    })
            }
            
        })
        
        let user:Users?
        
        if UserDefaults.standard.object(forKey: "currentUser") != nil{
            let data = UserDefaults.standard.object(forKey: "currentUser") as! Data
            user = try! JSONDecoder().decode(Users.self, from: data)
            print("user: \(user!.name)")
        }else{
            user = nil
        }
        
        
        //let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize.init(width: topCollectionView.frame.width-5, height: topCollectionView.frame.height-5)
    
        //topCollectionView.collectionViewLayout = layout
        
        //loadImage()
        
        productCollectionview.delegate = self
        productCollectionview.dataSource = self
        productCollectionview.isScrollEnabled = true
        
        
        //productCollectionview.collectionViewLayout = UICollectionViewFlowLayout()
        
        // get the VC's specific nav bar
        let topbar = self.navigationController!.navigationBar
        UIManipulation.shadowTopBar(topbar)
    }
    
    func getProducts(completion:@escaping ([Products]) -> ()) {
        let productRef = Database.database().reference()
        var prdts:[Products] = []
        productRef.observeSingleEvent(of: .value, with: {snapshot in
            for products2 in snapshot.childSnapshot(forPath: "HomeProducts").children {
                
                let snap = products2 as! DataSnapshot
                let pds = snap.value as! [String:AnyObject]
                prdts.append(self.dictProductsConversion(dict: pds))
            }
            completion(prdts)
        })
    }
    
    func loadImage2(loopEnd: Int, strArray: [String], completionHandler:@escaping ([UIImage]) -> Void){
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = true
        config.waitsForConnectivity = true
        let sesh = URLSession(configuration: config)
        var imgarrPic2:[UIImage] = []
        
        for position in 0..<loopEnd {
            
            let url2 = URL(string: strArray[position])
            
            let data = sesh.dataTask(with: url2!) {data, _, error in
                
                if data != nil && error == nil {
                    
                    let data3 = data!
                    let image = UIImage(data: data3)!
                    imgarrPic2.append(image)
                    //print("position: \(position), images: \(imgarrPic.count)")
                    if position == loopEnd - 1 {
                      completionHandler(imgarrPic2)
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
    
    func dictProductsConversion(dict:[String:AnyObject]) -> Products {
        
        let product = Products(Price: dict["Price"] as! String, Pname: dict["Pname"] as! String, description: dict["description"] as! String, Category: dict["Category"] as! String, gender: dict["gender"] as! String, date: dict["date"] as! String, pid: dict["pid"] as! String, time: dict["time"] as! String, Imageurllist: dict["Imageurllist"] as! [String])
        
        return product
    }

}

extension correctHomeViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard!.instantiateViewController(identifier: "productView") as! ProductViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        self.view.showToast(toastMessage: "The number \(String(indexPath.item)) is the current number of the cells", duration: 2)
    }
}

extension correctHomeViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var pint = 0
       
        pint = self.products.count
        print("pint: \(pint)")
        
        if pint == 0 {
            print("pint2 is zero: \(pint)")
            return 7
        }else{
            print("pint2 is not zero: \(pint)")
            return pint
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell2", for: indexPath) as! ProductsViewCell
        
        DispatchQueue.main.async {
            print("cellForItemAt called")
            cell.cornerRadius()
            if self.pImgListsArray.count != 0 {
                print("imagearray: \(self.pImgListsArray.count) in total")
                if self.pImgListsArray.indices.contains(indexPath.row) {
                    
                    let pp = self.pImgListsArray[indexPath.row]
                    DispatchQueue.main.async {
                        cell.productImage.image = pp[0]
                    }
                }
                
            }else{
                cell.productImage.image = UIImage(named: "pwPic")
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "productHeader", for: indexPath) as! HeaderCollectionReusableView
        print("supp view called")
        header.configure()
        return header
        
    }
    
}

extension correctHomeViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
            let inset = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
            edgeInsetPadding = Int(inset.left + inset.right)
            return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = productCollectionview.frame
        return CGSize(width: size.width/2.2, height: size.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
            return CGFloat(self.miniumSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       
            return CGFloat(self.miniumSpacing)
    }
}
