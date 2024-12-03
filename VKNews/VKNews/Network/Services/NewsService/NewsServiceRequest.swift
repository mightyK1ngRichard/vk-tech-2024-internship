//
//  NewsServiceRequest.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

struct NewsServiceRequest {
    let apiKey: String
    let query: String
    let page: String
    let pageSize: String
}
