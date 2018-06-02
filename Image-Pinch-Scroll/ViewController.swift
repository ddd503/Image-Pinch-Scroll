//
//  ViewController.swift
//  Image-Pinch-Scroll
//
//  Created by kawaharadai on 2018/06/02.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var navibar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 制約の付け直し（スクロールビューのバウンドをつけるためimageViewのheightをスクロールより1大きくする）
        NSLayoutConstraint(item: self.imageView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .height,
                           multiplier: 1.0,
                           constant: -(self.navibar.frame.size.height + UIApplication.shared.statusBarFrame.height) + 1).isActive = true
    }
    
    private func setup() {
        self.navibar.delegate = self
        self.scrollView.delegate = self
        
        // UIWebViewのデフォルトは2.2
        self.scrollView.maximumZoomScale = 2.5
        // UIWebViewのデフォルトは1.0
        self.scrollView.minimumZoomScale = 1.0
        // 横スクロールバーを消す
        self.scrollView.showsHorizontalScrollIndicator = false
        // 複数方向へのスクロールを禁止（スクロール開始時の方向のみ進める）
        self.scrollView.isDirectionalLockEnabled = true
        
        // タップジェスチャーの作成
        let doubleTapGesture = UITapGestureRecognizer(target: self,
                                                      action: #selector(ViewController.doubleTap(gesture:)))
        // ハンドリングするタップ数を指定（今回はダブルタップ）
        doubleTapGesture.numberOfTapsRequired = 2
        // imageViewのタッチ判定有効にする
        imageView.isUserInteractionEnabled = true
        // タップイベントを追加
        imageView.addGestureRecognizer(doubleTapGesture)
    }
    
    // MARK: - Action
    /// ダブルタップで拡大、標準サイズへの戻りを繰り返す
    @objc func doubleTap(gesture: UITapGestureRecognizer) -> Void {
        // 拡大率を戻す
        self.scrollView.setZoomScale(1.0, animated: true)
    }
}

extension ViewController: UINavigationBarDelegate {
    // ステータスバーの上にナビバーを被せる
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // 縮尺を変更するViewを返す
        return self.imageView
    }
}
