import SwiftUI

struct OutfitBuilder: View {
    private var likedItems: [OutfitItem] {
        dresses.filter { $0.isLiked } +
        tops.filter { $0.isLiked } +
        bottoms.filter { $0.isLiked } +
        shoes.filter { $0.isLiked } +
        bags.filter { $0.isLiked }
    }
    @State private var dresses: [OutfitItem] = [
        .init(name: "dress1", category: .dress),
        .init(name: "dress2", category: .dress),
        .init(name: "dress3", category: .dress),
        .init(name: "dress4", category: .dress),
        .init(name: "dress5", category: .dress),
        .init(name: "dress6", category: .dress)
    ]
    @State private var tops: [OutfitItem] = [
        .init(name: "top1", category: .top),
        .init(name: "top2", category: .top),
        .init(name: "top3", category: .top),
        .init(name: "top4", category: .top),
        .init(name: "top5", category: .top),
        .init(name: "top6", category: .top),
        .init(name: "top7", category: .top),
        .init(name: "top8", category: .top),
        .init(name: "top9", category: .top),
        .init(name: "top10", category: .top),
        .init(name: "top11", category: .top),
        .init(name: "top12", category: .top),
        .init(name: "top13", category: .top),
        .init(name: "top14", category: .top)
    ]
    @State private var bottoms: [OutfitItem] = [
        .init(name: "bottom1", category: .bottom),
        .init(name: "bottom2", category: .bottom),
        .init(name: "bottom3", category: .bottom),
        .init(name: "bottom4", category: .bottom),
        .init(name: "bottom5", category: .bottom),
        .init(name: "bottom6", category: .bottom),
        .init(name: "bottom7", category: .bottom),
        .init(name: "bottom8", category: .bottom),
        .init(name: "bottom9", category: .bottom),
        .init(name: "bottom10", category: .bottom),
        .init(name: "bottom11", category: .bottom),
        .init(name: "bottom12", category: .bottom),
        .init(name: "bottom13", category: .bottom),
        .init(name: "bottom14", category: .bottom),
        .init(name: "bottom15", category: .bottom)
    ]
    @State private var shoes: [OutfitItem] = [
        .init(name: "shoe1", category: .shoe),
        .init(name: "shoe2", category: .shoe),
        .init(name: "shoe3", category: .shoe),
        .init(name: "shoe4", category: .shoe),
        .init(name: "shoe5", category: .shoe),
        .init(name: "shoe6", category: .shoe),
        .init(name: "shoe7", category: .shoe),
        .init(name: "shoe8", category: .shoe),
        .init(name: "shoe9", category: .shoe),
        .init(name: "shoe10", category: .shoe),
        .init(name: "shoe11", category: .shoe),
        .init(name: "shoe12", category: .shoe)
    ]
    @State private var bags: [OutfitItem] = [
        .init(name: "bag1", category: .bag),
        .init(name: "bag2", category: .bag),
        .init(name: "bag3", category: .bag),
        .init(name: "bag4", category: .bag),
        .init(name: "bag5", category: .bag),
        .init(name: "bag6", category: .bag),
        .init(name: "bag7", category: .bag),
        .init(name: "bag8", category: .bag)
    ]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                Text("Liked")
                    .foregroundStyle(Color(.white))
                    .fontWeight(.heavy)
                    .underline(true)
                
                if likedItems == [] {
                    HStack {
                        Spacer()
                        Text("still looking for THE outfit")
                            .foregroundStyle(Color(.gray))
                        Spacer()
                    }
                    .frame(height: 80)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(likedItems) { item in
                            HStack(alignment: .top, spacing: 4) {
                                Image(item.name)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 100)
                                
//                                Button {
//                                    item.isLiked = false
//                                } label: {
//                                    Image(systemName: "xmark.circle.fill")
//                                }
                            }
                        }
                    }
                }
                
                CategorySection(width: 80, height: 220, title: "Dresses", items: $dresses)
                CategorySection(width: 80,height: 140, title: "Tops", items: $tops)
                CategorySection(width: 80,height: 180, title: "Bottoms", items: $bottoms)
                CategorySection(width: 60, height: 120, title: "Shoes", items: $shoes)
                CategorySection(width: 60, height: 200, title: "Bags", items: $bags)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 23/255, green: 23/255, blue: 23/255))
    }
}

private struct OutfitItemView: View {
    var width: CGFloat? = nil
    var height: CGFloat
    @Binding var item: OutfitItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Image(item.name)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .onTapGesture(count: 2) {
                    item.isLiked.toggle()
                }
            
            Button {
                item.isLiked.toggle()
            } label: {
                Image(systemName: item.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(item.isLiked ? .red : .white)
                    .font(.title2)
                    .animation(.bouncy, value: item.isLiked)
            }
        }
//        .frame(width: 120)
//        .background(Color(.systemBackground))
//        .shadow(radius: 3)
    }
}

private struct CategorySection: View {
    var width: CGFloat? = nil
    var height: CGFloat
    let title: String
    @Binding var items: [OutfitItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(Color(.white))
                .fontWeight(.heavy)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach($items) { $item in
                        OutfitItemView(width: width, height: height, item: $item)
                    }
                }
            }
        }
    }
}

private class Closet{
    let dresses: [OutfitItem] = [
        .init(name: "dress1", category: .dress),
        .init(name: "dress2", category: .dress),
        .init(name: "dress3", category: .dress),
        .init(name: "dress4", category: .dress),
        .init(name: "dress5", category: .dress),
        .init(name: "dress6", category: .dress)
    ]
    let tops: [OutfitItem] = [
        .init(name: "top1", category: .top),
        .init(name: "top2", category: .top),
        .init(name: "top3", category: .top),
        .init(name: "top4", category: .top),
        .init(name: "top5", category: .top),
        .init(name: "top6", category: .top),
        .init(name: "top7", category: .top),
        .init(name: "top8", category: .top),
        .init(name: "top9", category: .top),
        .init(name: "top10", category: .top),
        .init(name: "top11", category: .top),
        .init(name: "top12", category: .top),
        .init(name: "top13", category: .top),
        .init(name: "top14", category: .top)
    ]
    let bottoms: [OutfitItem] = [
        .init(name: "bottom1", category: .bottom),
        .init(name: "bottom2", category: .bottom),
        .init(name: "bottom3", category: .bottom),
        .init(name: "bottom4", category: .bottom),
        .init(name: "bottom5", category: .bottom),
        .init(name: "bottom6", category: .bottom),
        .init(name: "bottom7", category: .bottom),
        .init(name: "bottom8", category: .bottom),
        .init(name: "bottom9", category: .bottom),
        .init(name: "bottom10", category: .bottom),
        .init(name: "bottom11", category: .bottom),
        .init(name: "bottom12", category: .bottom),
        .init(name: "bottom13", category: .bottom),
        .init(name: "bottom14", category: .bottom),
        .init(name: "bottom15", category: .bottom)
    ]
    let shoes: [OutfitItem] = [
        .init(name: "shoe1", category: .shoe),
        .init(name: "shoe2", category: .shoe),
        .init(name: "shoe3", category: .shoe),
        .init(name: "shoe4", category: .shoe),
        .init(name: "shoe5", category: .shoe),
        .init(name: "shoe6", category: .shoe),
        .init(name: "shoe7", category: .shoe),
        .init(name: "shoe8", category: .shoe),
        .init(name: "shoe9", category: .shoe),
        .init(name: "shoe10", category: .shoe),
        .init(name: "shoe11", category: .shoe),
        .init(name: "shoe12", category: .shoe)
    ]
    let bags: [OutfitItem] = [
        .init(name: "bag1", category: .bag),
        .init(name: "bag2", category: .bag),
        .init(name: "bag3", category: .bag),
        .init(name: "bag4", category: .bag),
        .init(name: "bag5", category: .bag),
        .init(name: "bag6", category: .bag),
        .init(name: "bag7", category: .bag),
        .init(name: "bag8", category: .bag)
    ]
//    let tops = ["top1", "top2", "top3", "top4", "top5", "top6", "top7", "top8", "top9", "top10", "top11", "top12", "top13", "top14"]
//    let bottoms = ["bottom1", "bottom2", "bottom3", "bottom5", "bottom6", "bottom7", "bottom8", "bottom9", "bottom10", "bottom11", "bottom12", "bottom13", "bottom14", "bottom15"]
//    let shoes = ["shoe1", "shoe2", "shoe3", "shoe4", "shoe5", "shoe6", "shoe7", "shoe8", "shoe9", "shoe10", "shoe11", "shoe12"]
//    let bags = ["bag1", "bag2", "bag3", "bag4", "bag5", "bag6", "bag7", "bag8"]
}

private struct OutfitItem: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var isLiked: Bool = false
    var category: Category
}

enum Category: String, Identifiable {
    case dress, top, bottom, shoe, bag
    var id: String { rawValue }
}

#Preview {
    OutfitBuilder()
}
