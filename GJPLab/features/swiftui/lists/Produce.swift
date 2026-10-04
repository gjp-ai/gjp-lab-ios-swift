import Foundation

/// Sample rows for the Lists & grids topic. Bundled in code so the screen works offline and in previews.
struct Produce: Identifiable, Hashable {
    enum Kind: CaseIterable {
        case fruit, vegetable

        var title: String {
            switch self {
            case .fruit: "Fruit"
            case .vegetable: "Vegetables"
            }
        }
    }

    let name: String
    let emoji: String
    let kind: Kind
    var isFavorite = false

    /// Names are unique in the sample data, so the name is a stable identity.
    var id: String { name }

    static let samples: [Produce] = [
        Produce(name: "Apple", emoji: "🍎", kind: .fruit),
        Produce(name: "Banana", emoji: "🍌", kind: .fruit),
        Produce(name: "Cherries", emoji: "🍒", kind: .fruit),
        Produce(name: "Grapes", emoji: "🍇", kind: .fruit),
        Produce(name: "Kiwi", emoji: "🥝", kind: .fruit),
        Produce(name: "Lemon", emoji: "🍋", kind: .fruit),
        Produce(name: "Mango", emoji: "🥭", kind: .fruit),
        Produce(name: "Peach", emoji: "🍑", kind: .fruit),
        Produce(name: "Pineapple", emoji: "🍍", kind: .fruit),
        Produce(name: "Strawberry", emoji: "🍓", kind: .fruit),
        Produce(name: "Watermelon", emoji: "🍉", kind: .fruit),
        Produce(name: "Avocado", emoji: "🥑", kind: .vegetable),
        Produce(name: "Broccoli", emoji: "🥦", kind: .vegetable),
        Produce(name: "Carrot", emoji: "🥕", kind: .vegetable),
        Produce(name: "Corn", emoji: "🌽", kind: .vegetable),
        Produce(name: "Cucumber", emoji: "🥒", kind: .vegetable),
        Produce(name: "Eggplant", emoji: "🍆", kind: .vegetable),
        Produce(name: "Garlic", emoji: "🧄", kind: .vegetable),
        Produce(name: "Mushroom", emoji: "🍄", kind: .vegetable),
        Produce(name: "Potato", emoji: "🥔", kind: .vegetable),
    ]
}
