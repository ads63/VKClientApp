//
//  RealmInsertOperation.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 03.02.2022.
//

import Foundation
import RealmSwift

class RealmInsertOperation<T: Object & Decodable>: Operation {
    private var data: [T]?

    override func main() {
        guard let parseDataOperation = dependencies
            .filter({ $0 is ParseDataOperation<Response<T>> }).first as?
            ParseDataOperation<Response<T>>,
            let data = parseDataOperation.parsedData?.list
        else { return }
        insertData(data: data) // insert parsed data
    }

    private func insertData(data: [T]) {
        do {
            let realm = try Realm(configuration: RealmService.config)
            realm.beginWrite()
            realm.add(data, update: .all)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
