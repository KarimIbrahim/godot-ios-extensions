import SwiftGodot

public let godotTypes: [Wrapped.Type] = [
    Battery.self
]

#initSwiftExtension(cdecl: "swift_entry_point", types: godotTypes)
