//
//  RestApiOperation.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 02.02.2022.
//

import Alamofire
import Foundation

class RestApiOperation: AsyncOperation {
    override func cancel() {
        request.cancel()
        super.cancel()
    }

    private var request: DataRequest

    var data: Data?

    override func main() {
        request
            .resume()
            .validate(statusCode: 200 ..< 201)
            .validate(contentType: ["application/json"])
            .responseData(queue: DispatchQueue.global()) { [weak self]
                response in
                self?.data = response.data
                self?.state = .finished
            }
    }

    init(request: DataRequest) {
        self.request = request
    }
}
