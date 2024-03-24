//Created by Halbus Development

import SwiftUI

struct ProductsCellView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("Price: $" + "\(product.price ?? 0)")
                Text("Rating: " + "\(product.rating ?? 0)")
                Text("Category: \(product.category ?? "n/a")")
                Text("Brand: \(product.brand ?? "n/a")")
            }
            .font(.callout)
            .foregroundStyle(.secondary)
        }
    }
}
