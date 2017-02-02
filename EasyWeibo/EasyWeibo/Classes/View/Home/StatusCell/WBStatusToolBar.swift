//
//  WBStatusToolBar.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/24.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {

    var viewModel:WBStatusViewModel?{
    
        didSet{
        
//            retweetButton.setTitle("\(viewModel?.status.reposts_count)",for:[])
//            commentButton.setTitle("\(viewModel?.status.comments_count)",for:[])
//            likeButton.setTitle("\(viewModel?.status.attitudes_count)",for:[])

            retweetButton.setTitle(viewModel?.retweetStr, for: [])
            
            commentButton.setTitle(viewModel?.commentStr, for: [])
            
            likeButton.setTitle(viewModel?.likeStr, for: [])
        }
    }
    
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    
}
