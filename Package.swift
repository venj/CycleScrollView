import PackageDescription

let package = Package(
    name: "CycleScrollView",
    dependencies: .Package(url: "https://github.com/onevcat/Kingfisher.git", versions: Version(2,0,0) ..< Version(3,0,0))
)
