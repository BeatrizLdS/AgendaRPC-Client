protocol ClientProtocol {
    associatedtype Connection
    var connection: Connection? { get set }
}
