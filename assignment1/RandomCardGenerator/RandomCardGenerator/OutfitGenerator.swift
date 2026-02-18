//
//  OutfitGenerator.swift
//  RandomCardGenerator
//
//  Created by Amina Yegenberdiyeva on 18.02.2026.
//

import SwiftUI

struct OutfitGenerator: View {
    private let closet = Closet()
    
    @State private var outfit: Outfit = .empty
    @State private var favorites = Favorites()
    @State private var count: Int = 0
    @State private var pinned: [ItemCategory: Int] = [:]
    
    private func pin(_ category: ItemCategory) -> Int? {
        pinned[category]
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            if !outfit.hasGeneratedOutfit {
                Spacer()
                
                Text("#OOTD")
                    .font(.system(size: 76, weight: .bold))
                    .foregroundStyle(Color(.white))
            } else {
                Text("Outfit Generator")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color(.white))
            }
            
            Spacer()
            
            if outfit.hasGeneratedOutfit {
                OutfitView(closet: closet, outfit: outfit, favorites: $favorites, pinned: $pinned)
            }
            
            Spacer()
            
            Button {
                var newOutfit = generateOutfitPinned()
                
                while newOutfit == outfit {
                    newOutfit = generateOutfitPinned()
                }
                
                outfit = newOutfit
                count += 1
            } label: {
                Text(outfit.hasGeneratedOutfit ? "Generate Again" : "Generate Outfit")
            }
            .foregroundStyle(Color(.white))
            .underline(true)
            
            Text("Count: \(count)")
                .foregroundStyle(Color(.white))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 23/255, green: 23/255, blue: 23/255))
    }
    
    private func generateOutfitPinned() -> Outfit {
        let wearDress: Bool
        if pin(.dress) != nil {
            wearDress = true
        } else if pin(.top) != nil || pin(.bottom) != nil {
            wearDress = false
        } else {
            wearDress = Bool.random()
        }
        
        let show = pin(.shoe) ?? Int.random(in: 0..<closet.shoes.count)
        let bag = pin(.bag) ?? Int.random(in: 0..<closet.bags.count)
        
        if wearDress {
            let dress = pin(.dress) ?? Int.random(in: 0..<closet.dresses.count)
            
            return Outfit(
                dressIndex: dress,
                topIndex: nil,
                bottomIndex: nil,
                shoeIndex: show,
                bagIndex: bag
            )
        } else {
            let top = pin(.top) ?? Int.random(in: 0..<closet.tops.count)
            let bottom = pin(.bottom) ?? Int.random(in: 0..<closet.bottoms.count)
            
            return Outfit(
                dressIndex: nil,
                topIndex: top,
                bottomIndex: bottom,
                shoeIndex: show,
                bagIndex: bag
            )
        }
    }
}

private struct Closet {
    let dresses = ["dress1", "dress2", "dress3", "dress4", "dress5", "dress6"]
    let tops = ["top1", "top2", "top3", "top4", "top5", "top6", "top7", "top8", "top9", "top10", "top11", "top12", "top13", "top14"]
    let bottoms = ["bottom1", "bottom2", "bottom3", "bottom5", "bottom6", "bottom7", "bottom8", "bottom9", "bottom10", "bottom11", "bottom12", "bottom13", "bottom14", "bottom15"]
    let shoes = ["shoe1", "shoe2", "shoe3", "shoe4", "shoe5", "shoe6", "shoe7", "shoe8", "shoe9", "shoe10", "shoe11", "shoe12"]
    let bags = ["bag1", "bag2", "bag3", "bag4", "bag5", "bag6", "bag7", "bag8"]
}

private struct Outfit: Equatable {
    var dressIndex: Int? = nil
    var topIndex: Int? = nil
    var bottomIndex: Int? = nil
    var shoeIndex: Int? = nil
    var bagIndex: Int? = nil
    
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

private struct OutfitView: View {
    let closet: Closet
    let outfit: Outfit
    
    @Binding var favorites: Favorites
    @Binding var pinned: [ItemCategory: Int]
    
    private func toggglePin(category: ItemCategory, index: Int) {
        if pinned[category] == index {
            pinned[category] = nil
        } else {
            pinned[category] = index
            
            if category == .dress {
                pinned[.top] = nil
                pinned[.bottom] = nil
            } else if category == .top || category == .bottom {
                pinned[.dress] = nil
            }
        }
    }
    
    var body: some View {
        HStack {
            if let dressIndex = outfit.dressIndex {
                VStack {
                    OutfitItemView(
                        imageName: closet.dresses[dressIndex],
                        isLiked: favorites.contains(.init(category: .dress, index: dressIndex)),
                        isPinned: pinned[.dress] == dressIndex,
                        height: 380,
                        isScaledToFit: false,
                        width: 180,
                        onLikeTap: {
                            favorites.toggle(.init(category: .dress, index: dressIndex));
                        },
                        onPinTap: {
                            toggglePin(category: .dress, index: dressIndex)
                        }
                
                    )
                    
                    Spacer(minLength: 100)
                }
                .frame(maxWidth: .infinity)
            } else if let topIndex = outfit.topIndex, let bottomIndex = outfit.bottomIndex {
                VStack {
                    OutfitItemView(
                        imageName: closet.tops[topIndex],
                        isLiked: favorites.contains(.init(category: .top, index: topIndex)),
                        isPinned: pinned[.top] == topIndex,
                        height: 160,
                        isScaledToFit: true,
                        width: 180,
                        onLikeTap: {
                            favorites.toggle(.init(category: .top, index: topIndex))
                        },
                        onPinTap: {
                            toggglePin(category: .top, index: topIndex)
                        }
                    )
                    
                    OutfitItemView(
                        imageName: closet.bottoms[bottomIndex],
                        isLiked: favorites.contains(.init(category: .bottom, index: bottomIndex)),
                        isPinned: pinned[.bottom] == bottomIndex,
                        height: 300,
                        isScaledToFit: true,
                        onLikeTap: {
                           favorites.toggle(.init(category: .bottom, index: bottomIndex))
                       },
                        onPinTap: {
                            toggglePin(category: .bottom, index: bottomIndex)
                        }
                    )
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                Spacer()
                
                if let bagIndex = outfit.bagIndex {
                    OutfitItemView(
                        imageName: closet.bags[bagIndex],
                        isLiked: favorites.contains(.init(category: .bag, index: bagIndex)),
                        isPinned: pinned[.bag] == bagIndex,
                        height: 240,
                        isScaledToFit: false,
                        width: 120,
                        onLikeTap: {
                            favorites.toggle(.init(category: .bag, index: bagIndex))
                        },
                        onPinTap: {
                            toggglePin(category: .bag, index: bagIndex)
                        }
                    )
                }
                
                if let shoeIndex = outfit.shoeIndex {
                    OutfitItemView(
                        imageName: closet.shoes[shoeIndex],
                        isLiked: favorites.contains(.init(category: .shoe, index: shoeIndex)),
                        isPinned: pinned[.shoe] == shoeIndex,
                        height: 180,
                        isScaledToFit: true,
                        onLikeTap: {
                            favorites.toggle(.init(category: .shoe, index: shoeIndex))
                        },
                        onPinTap: {
                            toggglePin(category: .shoe, index: shoeIndex)
                        }
                    )
                }
            }
        }
        .frame(height: 500)
    }
}

private struct OutfitItemView: View {
    let imageName: String
    let isLiked: Bool
    let isPinned: Bool
    let height: CGFloat
    let isScaledToFit: Bool
    
    var width: CGFloat? = nil
    let onLikeTap: () -> Void
    let onPinTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            image
            VStack (spacing: 12) {
                LikeButton(isLiked: isLiked, action: onLikeTap)
                PinButton(isPinned: isPinned, action: onPinTap)
            }
        }
    }
    
    @ViewBuilder
    private var image: some View {
        if isScaledToFit {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .onTapGesture(count: 2) {
                    onLikeTap()
                }
                .frame(height: height)
                .frame(width: width)
        } else {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .onTapGesture(count: 2) {
                    onLikeTap()
                }
                .frame(height: height)
                .frame(width: width)
                .clipped()
        }
    }
}

private struct LikeButton: View {
    let isLiked: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .white)
                .font(.title2)
                .animation(.bouncy, value: isLiked)
        }
        .buttonStyle(.plain)
    }
}

private struct PinButton: View {
    let isPinned: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: isPinned ? "pin.fill" : "pin")
                .foregroundColor(.white)
                .font(.title2)
                .animation(.bouncy, value: isPinned)
                .rotationEffect(.degrees(isPinned ? 45 : 0))
        }
        .buttonStyle(.plain)
    }
}

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
        if ids.contains(id) { ids.remove(id) }
        else { ids.insert(id) }
    }
    
    func contains(_ id: ItemID) -> Bool {
        ids.contains(id)
    }
}

#Preview {
    OutfitGenerator()
}
