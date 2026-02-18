import SwiftUI

// MARK: - Screen

struct ContentView: View {
    private let closet = Closet()

    @State private var outfit: Outfit = .empty
    @State private var favorites = Favorites()

    var body: some View {
        VStack(spacing: 20) {
            Text("Closet Organizer")
                .font(.largeTitle.bold())

            if outfit.hasGeneratedOutfit {
                OutfitView(
                    closet: closet,
                    outfit: outfit,
                    favorites: $favorites
                )
            }

            Spacer()

            Button {
                outfit = Outfit.random(using: closet)
            } label: {
                Text(outfit.hasGeneratedOutfit ? "Generate Again" : "Generate Outfit")
                    .font(.headline)
                    .padding()
                    .underline()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
            }
        }
        .padding()
    }
}

// MARK: - Closet (data)

private struct Closet {
    let dresses = ["dress1", "dress2", "dress3", "dress4", "dress5", "dress6"]
    let tops = ["top1", "top2", "top3", "top4", "top5", "top6", "top7", "top8", "top9", "top10", "top11", "top12", "top13", "top14"]
    let bottoms = ["bottom1", "bottom2", "bottom3", "bottom5", "bottom6", "bottom7", "bottom8", "bottom9", "bottom10", "bottom11", "bottom12", "bottom13", "bottom14", "bottom15"]
    let shoes = ["shoe1", "shoe2", "shoe3", "shoe4", "shoe5", "shoe6", "shoe7", "shoe8", "shoe9", "shoe10", "shoe11", "shoe12"]
    let bags = ["bag1", "bag2", "bag3", "bag4", "bag5", "bag6", "bag7", "bag8"]
}

// MARK: - Outfit (state)

private struct Outfit: Equatable {
    var dressIndex: Int?
    var topIndex: Int?
    var bottomIndex: Int?
    var shoeIndex: Int?
    var bagIndex: Int?

    static let empty = Outfit(dressIndex: nil, topIndex: nil, bottomIndex: nil, shoeIndex: nil, bagIndex: nil)

    var hasGeneratedOutfit: Bool {
        dressIndex != nil || (topIndex != nil && bottomIndex != nil)
    }

    static func random(using closet: Closet) -> Outfit {
        let wearDress = Bool.random()

        let shoe = Int.random(in: 0..<closet.shoes.count)
        let bag = Int.random(in: 0..<closet.bags.count)

        if wearDress {
            return Outfit(
                dressIndex: Int.random(in: 0..<closet.dresses.count),
                topIndex: nil,
                bottomIndex: nil,
                shoeIndex: shoe,
                bagIndex: bag
            )
        } else {
            return Outfit(
                dressIndex: nil,
                topIndex: Int.random(in: 0..<closet.tops.count),
                bottomIndex: Int.random(in: 0..<closet.bottoms.count),
                shoeIndex: shoe,
                bagIndex: bag
            )
        }
    }
}

// MARK: - Favorites

private enum ItemCategory: String, Hashable {
    case dress, top, bottom, shoe, bag
}

private struct ItemID: Hashable {
    let category: ItemCategory
    let index: Int
}

private struct Favorites {
    private(set) var ids: Set<ItemID> = []

    mutating func toggle(_ id: ItemID) {
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
    }

    func contains(_ id: ItemID) -> Bool {
        ids.contains(id)
    }
}

// MARK: - Outfit view

private struct OutfitView: View {
    let closet: Closet
    let outfit: Outfit
    @Binding var favorites: Favorites

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            topRow
            shoesRow
        }
    }

    @ViewBuilder
    private var topRow: some View {
        HStack(alignment: .bottom, spacing: 16) {
            mainClothes
            bag
        }
    }

    @ViewBuilder
    private var mainClothes: some View {
        if let dressIndex = outfit.dressIndex {
            OutfitItemView(
                imageName: closet.dresses[dressIndex],
                isLiked: favorites.contains(.init(category: .dress, index: dressIndex)),
                height: 400
            ) {
                favorites.toggle(.init(category: .dress, index: dressIndex))
            }
        } else if let topIndex = outfit.topIndex, let bottomIndex = outfit.bottomIndex {
            VStack(spacing: 12) {
                OutfitItemView(
                    imageName: closet.tops[topIndex],
                    isLiked: favorites.contains(.init(category: .top, index: topIndex)),
                    height: 220
                ) {
                    favorites.toggle(.init(category: .top, index: topIndex))
                }

                OutfitItemView(
                    imageName: closet.bottoms[bottomIndex],
                    isLiked: favorites.contains(.init(category: .bottom, index: bottomIndex)),
                    height: 220
                ) {
                    favorites.toggle(.init(category: .bottom, index: bottomIndex))
                }
            }
        }
    }

    @ViewBuilder
    private var bag: some View {
        if let bagIndex = outfit.bagIndex {
            OutfitItemView(
                imageName: closet.bags[bagIndex],
                isLiked: favorites.contains(.init(category: .bag, index: bagIndex)),
                height: 160
            ) {
                favorites.toggle(.init(category: .bag, index: bagIndex))
            }
        }
    }

    @ViewBuilder
    private var shoesRow: some View {
        if let shoeIndex = outfit.shoeIndex {
            OutfitItemView(
                imageName: closet.shoes[shoeIndex],
                isLiked: favorites.contains(.init(category: .shoe, index: shoeIndex)),
                height: 160
            ) {
                favorites.toggle(.init(category: .shoe, index: shoeIndex))
            }
        }
    }
}

// MARK: - Reusable components

private struct OutfitItemView: View {
    let imageName: String
    let isLiked: Bool
    let height: CGFloat

    var width: CGFloat = 120
    let onLikeTap: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()

            LikeButton(isLiked: isLiked, action: onLikeTap)
        }
    }
}

private struct LikeButton: View {
    let isLiked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .black)
                .font(.title2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
