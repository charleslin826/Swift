//
//  DemoURLs.swift
//  Cassini
//
//  Created by Charles on 2018/3/25.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import Foundation

struct DemoURLs{
    
    static let standford = Bundle.main.url(forResource: "mac", withExtension: "png")
    //  static let standford = URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Standford_Oval_September_2013_panorama.jpg")
    
    static var NASA: Dictionary<String,URL> = {
        let NASAURLStrings = [
            "Cassini" : "https://c2.staticflickr.com/6/5597/15357921727_824b48a91f_b.jpg", //Due to fail on Cassini, this is ISS(International Space Station)
            "Earth" : "https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
            "Saturn" : "https://www.nasa.gov/sites/default/files/saturn_collage.jpg"
        ]
        var urls = Dictionary<String, URL>()
        for (key, value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
