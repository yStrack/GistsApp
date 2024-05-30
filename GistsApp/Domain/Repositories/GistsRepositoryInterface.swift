//
//  GistRepositoryInterface.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 29/05/24.
//

import Foundation

protocol GistsRepositoryInterface {
    func getGists(page: Int, completion: @escaping (Result<[Gist], Error>) -> Void)
}
