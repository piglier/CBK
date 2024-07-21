//
//  Array+.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

extension Array {
    
    public func merge(
        _ collection: [Element],
        on projection: (Element, Element) -> Bool,
        uniquingKeysWith combine: (Element, Element) -> Element
    ) -> [Element] {
        var result: [Element] = self
        
        for element in collection {
            if let index = result.firstIndex(where: { projection($0, element) }) {
                let uniqued = combine(element, result[index])
                result[index] = uniqued
            } else {
                result.append(element)
            }
        }
        return result
    }
}
