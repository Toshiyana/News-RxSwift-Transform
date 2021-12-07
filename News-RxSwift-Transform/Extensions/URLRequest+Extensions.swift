//
//  URLRequest+Extensions.swift
//  News-RxSwift-Transform
//
//  Created by Toshiyana on 2021/12/07.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
    let url: URL
}

extension URLRequest {
    
    static func load<T>(resource: Resource<T>) -> Observable<T> {
        
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }.asObservable()

        // The above code works without error.
        // The below code doesn't work with error.(<- udemy code, why?)
//            }.map { data -> T? in
//                return try? JSONDecoder().decode(T.self, from: data)
//            }.asObservable()

        
    }
    
}
