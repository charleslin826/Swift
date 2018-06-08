//
//  imageViewController.swift
//  Cassini
//
//  Created by Charles on 2018/3/25.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import UIKit

class imageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: URL? {
        didSet {
            image = nil//imageView. can ignored
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    
    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageView = UIImageView()
    
    private func fetchImage() {
        if let url = imageURL {
            spinner.startAnimating()
           // do {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in //plus this weak self in so when user don't want it, it will leave the heap
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async { // run on the main when it is available
                    if let imageData = urlContents, url == self?.imageURL { // check url on the last minute in case user change mind
                        self?.image = UIImage(data: imageData)  //imageView.image can be simplified
                    }
                }
                // } catch let error {
                //     print(error)
                // }
            }
            
        }
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
//        if imageURL == nil {
//            imageURL = DemoURLs.standford
//        }
    }
}
