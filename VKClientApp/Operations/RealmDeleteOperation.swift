//
//  RealmDeleteOperation.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 03.02.2022.
//

import Foundation
import RealmSwift

class RealmDeleteOperation<T: Object & IdProtocol & Decodable>: Operation {
    private var result: Int?
    private var dataRef: ThreadSafeReference<T>?
    private var predicate: NSPredicate?

    override func main() {
        if let parseDataOperation = dependencies.first as?
            ParseDataOperation<ResponseCode>,
            parseDataOperation.parsedData?.result == 1
        {
            deleteData()
        } else {
            if let parseDataOperation = dependencies.first as?
                ParseDataOperation<Response<T>>,
                parseDataOperation.parsedData != nil
            {
                deleteData()
            }
        }
    }

    private func deleteData() {
        do {
            let realm = try Realm(configuration: RealmService.config)
            realm.beginWrite()
            if let predicate = predicate {
                realm.delete(realm.objects(T.self).filter(predicate))
            }
            if let dataRef = dataRef {
                if let data = realm.resolve(dataRef) {
                    predicate = NSPredicate(format: "id == %@",
                                            argumentArray: [data.id])
                    realm.delete(realm.objects(T.self).filter(predicate!))
                }
            }
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    init(data: T? = nil, predicate: NSPredicate? = nil) {
        if let data = data { self.dataRef = ThreadSafeReference(to: data) }
        if let predicate = predicate { self.predicate = predicate }
    }
}
