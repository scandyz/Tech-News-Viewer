//
//  Article.swift
//  Tech News Viewer
//
//  Created by Никита Бычков on 02/04/2019.
//  Copyright © 2019 Никита Бычков. All rights reserved.
//

import Foundation

struct Article: Codable {
    var source: Source
    var author: String
    var description: String
    var title: String
    var url: String
    var urlToImage: String
}
