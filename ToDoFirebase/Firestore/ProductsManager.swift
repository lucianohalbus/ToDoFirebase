//Created by Halbus Development

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProductsManager {
    
    static let share = ProductsManager()
    private init() { }
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    func productsDocument(productsId: String) -> DocumentReference {
        productsCollection.document(productsId)
    }
    
    func uploadProducts(product: Product) async throws {
        try productsDocument(productsId: product.id.description).setData(from: product, merge: false)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productsDocument(productsId: productId).getDocument(as: Product.self)
    }
    
    private func getAllProducts() async throws -> [Product] {
        try await productsCollection.getDocuments(as: Product.self)
    }
    
    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
        try await productsCollection.order(by:Product.CodingKeys.price.rawValue, descending: descending).getDocuments(as: Product.self)
    }
    
    private func getAllProductsFilteredByCategory(category: String) async throws -> [Product] {
        try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .getDocuments(as: Product.self)
    }
    
    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
        try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getDocuments(as: Product.self)
    }
    
    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?) async throws -> [Product] {
        if let descending, let category {
            return try await getAllProductsByPriceAndCategory(descending: descending, category: category)
        } else if let descending {
            return try await getAllProductsSortedByPrice(descending: descending)
        } else if let category {
            return try await getAllProductsFilteredByCategory(category: category)
        }
        
         return try await getAllProducts()
    }
}

extension Query {
//    func getDocuments2(as type: Product.Type) async throws -> [Product] {
//        let snapshot = try await self.getDocuments()
//        
//        var products: [Product] = []
//        for document in snapshot.documents {
//            let product = try document.data(as: Product.self)
//            products.append(product)
//        }
//        
//        return products
//    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
       return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
//        var products: [T] = []
//        for document in snapshot.documents {
//            let product = try document.data(as: T.self)
//            products.append(product)
//        }
//      return products
        

    }
}
