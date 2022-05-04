//
//  NewsCellViewModel.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 22/04/22.
//

struct NewsCellModel: Hashable {
    let url: String
    let imageURL: String
    let heading: String?
    let author: String?
    let content: String?
}
