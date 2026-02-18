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
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Outfit Generator")
                .font(.largeTitle.bold())
                .foregroundStyle(Color(.white))
            
            Spacer()
            
            if outfit.hasGeneratedOutfit {
                OutfitView(closet: closet, outfit: outfit)
            }
            
            Spacer()
            
            Button {
                outfit = Outfit.random(using: closet)
            } label: {
                Text(outfit.hasGeneratedOutfit ? "Generate Again" : "Generate Outfit")
            }
            .foregroundStyle(Color(.white))
            .underline(true)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 23/255, green: 23/255, blue: 23/255))
    }
    
//    private func generateOutfit() {
//        let wearDress = Bool.random()
//        
//        shoeIndex = Int.random(in: 0..<shoes.count)
//        bagIndex = Int.random(in: 0..<bags.count)
//        
//        if wearDress {
//            dressIndex = Int.random(in: 0..<dresses.count)
//            topIndex = nil
//            bottomIndex = nil
//        } else {
//            topIndex = Int.random(in: 0..<tops.count)
//            bottomIndex = Int.random(in: 0..<bottoms.count)
//            dressIndex = nil
//        }
//    }
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
                bagIndex: bag)
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
    
    var body: some View {
        HStack {
            if let dressIndex = outfit.dressIndex {
                VStack {
                    Image(closet.dresses[dressIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 480)
                    
                    Spacer(minLength: 140)
                }
                .frame(maxWidth: .infinity)
            } else if let topIndex = outfit.topIndex, let bottomIndex = outfit.bottomIndex {
                VStack {
                    Image(closet.tops[topIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                    
                    Image(closet.bottoms[bottomIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                Spacer()
                
                if let bagIndex = outfit.bagIndex {
                    Image(closet.bags[bagIndex])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 240)
                }
                
                if let shoeIndex = outfit.shoeIndex {
                    Image(closet.shoes[shoeIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                }
            }
        }
        .frame(height: 500)
    }
}

private enum ItemCategory: String, Hashable {
    case dress, top, bottom, shoe, bag
}

#Preview {
    OutfitGenerator()
}
