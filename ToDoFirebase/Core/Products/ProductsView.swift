//Created by Halbus Development

import SwiftUI

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published var selectedFileter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFileter = option
        self.getProducts()
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case smartphones
        case laptops
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            } else {
                return self.rawValue
            }
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.getProducts()
        
    }
    
    func getProducts() {
        Task {
            self.products = try await ProductsManager.share.getAllProducts(priceDescending: selectedFileter?.priceDescending, forCategory: selectedCategory?.categoryKey)
        }
    }
 
}

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductsCellView(product: product)
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \(viewModel.selectedFileter?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.filterSelected(option: option)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.categorySelected(option: option)
                            }
                        }
                    }
                }
            }
        })
        .onAppear {
            viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
