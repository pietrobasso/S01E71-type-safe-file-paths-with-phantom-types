protocol PathKind {}
enum Absolute: PathKind {}
enum Relative: PathKind {}

protocol FileType {}
enum Directory: FileType {}
enum File: FileType {}

/**
 A Type-Safe File Path that wraps an array of path components.
 
 # Type Parameters
 * `PathKind`: expresses if it's an absolute or relative path.
 * `FilePath`: expresses if a path points to a file or a directory.
 
 - Authors:
 - [Type-Safe File Paths with Phantom Types](https://talk.objc.io/episodes/S01E71-type-safe-file-paths-with-phantom-types) by Brandon Kase, Florian Kugler.
 */
struct Path<PathKind, FileType> {
    var components: [String]
    
    private init(_ components: [String]) {
        self.components = components
    }
}

extension Path where PathKind == Absolute {
    var rendered: String {
        return "/" + components.joined(separator: "/")
    }
}

extension Path where PathKind == Relative {
    var rendered: String {
        return components.joined(separator: "/")
    }
}

extension Path where FileType == Directory {
    init(directoryComponents: [String]) {
        self.components = directoryComponents
    }
    
    func appending(directory: String) -> Path<PathKind, Directory> {
        return Path<PathKind, Directory>(directoryComponents: components + [directory])
    }
    
    func appendingFile(_ file: String) -> Path<PathKind, File> {
        return Path<PathKind, File>(components + [file])
    }
    
    func appendingPath(directory: Path<Relative, Directory>) -> Path<PathKind, Directory> {
        return Path<PathKind, Directory>(components + directory.components)
    }
    
    func appendingFilePath(_ path: Path<Relative, File>) -> Path<PathKind, File> {
        return Path<PathKind, File>(components + path.components)
    }
}

let path = Path<Absolute, Directory>(directoryComponents: ["Users", "chris"])

let path1 = path.appending(directory: "Documents")
let path2 = path1.appendingFile("test.md")
//let path3 = path2.appendingFile("test.md")

print(path2.rendered)
