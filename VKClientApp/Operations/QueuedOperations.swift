//
//  QueuedOperations.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 03.02.2022.
//

import Alamofire
// import Foundation
// import UIKit

final class QueuedOperations {
    private let queue = OperationQueue()
    private let session = SessionSettings.instance
    private let host = SessionSettings.instance.host

    func getUserGroups(fieldList: [String] = [],
                       extended: Int = 1,
                       offset: Int = 0)
    {
        var fields = Set<String>(["photo_50"]) // set mandatory fields
        fields.formUnion(fieldList) // add user defined fields
        let path = EndPoint.getUserGroups.rawValue
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "offset": String(offset),
            "extended": String(extended),
            "fields": fields.joined(separator: ",")
        ]

        let request = AF.request(
            host + path,
            method: .get,
            parameters: parameters)
        let restApiOperation = RestApiOperation(request: request)
        let parseOperation = ParseDataOperation<Response<Group>>()
        let realmInsertOperation = RealmInsertOperation<Group>()
        parseOperation.addDependency(restApiOperation)
        realmInsertOperation.addDependency(parseOperation)
        queue.addOperations([restApiOperation,
                             parseOperation,
                             realmInsertOperation],
                            waitUntilFinished: false)
    }

    func leaveGroup(group: Group) {
        let path = EndPoint.leaveGroup.rawValue
        let id = group.id
        let parameters: Parameters = [
            "group_id": String(id),
            "v": session.api_version,
            "access_token": session.token
        ]
        let request = AF.request(
            host + path,
            method: .get,
            parameters: parameters)
        let restApiOperation = RestApiOperation(request: request)
        let parseOperation = ParseDataOperation<ResponseCode>()
        let realmDeleteOperation = RealmDeleteOperation<Group>(data: group)
        parseOperation.addDependency(restApiOperation)
        realmDeleteOperation.addDependency(parseOperation)
        queue.addOperations([restApiOperation,
                             parseOperation,
                             realmDeleteOperation],
                            waitUntilFinished: false)
    }

    func searchGroups(searchString: String = "",
                      type: String = "group",
                      offset: Int = 0)
    {
        let path = EndPoint.searchGroups.rawValue
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "type": type,
            "q": "\"" + searchString + "\"",
            "offset": String(offset)
        ]

        let request = AF.request(
            host + path,
            method: .get,
            parameters: parameters)
        let restApiOperation = RestApiOperation(request: request)
        let parseOperation = ParseDataOperation<Response<Group>>()
        let realmDeleteOperation =
            RealmDeleteOperation<Group>(
                predicate: NSPredicate(format: "memberValue == 0 AND adminValue == 0"))
        let realmInsertOperation = RealmInsertOperation<Group>()
        parseOperation.addDependency(restApiOperation)
        realmDeleteOperation.addDependency(parseOperation)
        realmInsertOperation.addDependency(parseOperation)
        realmInsertOperation.addDependency(realmDeleteOperation)
        queue.addOperations([restApiOperation,
                             parseOperation,
                             realmDeleteOperation,
                             realmInsertOperation],
                            waitUntilFinished: false)
    }

    func joinGroup(group: Group) {
        let path = EndPoint.joinGroup.rawValue
        let id = group.id
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "group_id": String(id)
        ]
        let request = AF.request(
            host + path,
            method: .get,
            parameters: parameters)
        let restApiOperation = RestApiOperation(request: request)
        let parseOperation = ParseDataOperation<ResponseCode>()
        let realmDeleteOperation = RealmDeleteOperation<Group>(data: group)
        parseOperation.addDependency(restApiOperation)
        realmDeleteOperation.addDependency(parseOperation)
        queue.addOperations([restApiOperation,
                             parseOperation,
                             realmDeleteOperation],
                            waitUntilFinished: false)
    }
}
