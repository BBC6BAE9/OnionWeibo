//
//  BBAnimationRefreshView.swift
//  EasyWeibo
//
//  Created by huang on 2017/2/1.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

class BBAnimationRefreshView: BBRefreshView {

    @IBOutlet weak var iconImg: UIImageView!
    
    override func awakeFromNib() {
        
        var array = [UIImage]()
        
        for i in 0...33 {
         
          let bImage = UIImage(named: "anim-\(i+1)")!
            array.append(bImage)
        }
       
        iconImg.image = UIImage.animatedImage(with:
            array , duration: 3)
        
    }
}
