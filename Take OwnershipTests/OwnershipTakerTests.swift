import XCTest
@testable import Take_Ownership

final class OwnershipTakerTests: XCTestCase {
    private let testUrl = URL(fileURLWithPath: "/path/to/file")
    
    func testTakeOwnershipFileNotFound() {
        // given
        let fileManagerMock = FileManagerMock(fileExists: false)
        let ownershipTaker = OwnershipTaker(fileManager: fileManagerMock)
        
        // when
        let result = ownershipTaker.takeOwnership(testUrl)
        
        // then
        XCTAssertFalse(result)
    }
    
    func testTakeOwnershipFileAttributesNotChanged() {
        // given
        let fileManagerMock = FileManagerMock(permissionsUpdated: false)
        let ownershipTaker = OwnershipTaker(fileManager: fileManagerMock)
        
        // when
        let result = ownershipTaker.takeOwnership(testUrl)
        
        // then
        XCTAssertFalse(result)
    }
    
    func testTakeOwnershipFileAttributesAreCorrect() {
        // given
        let fileManagerMock = FileManagerMock()
        let ownershipTaker = OwnershipTaker(fileManager: fileManagerMock)
        
        // when
        let result = ownershipTaker.takeOwnership(testUrl)
        
        // then
        XCTAssertTrue(result)
    }
}

private class FileManagerMock: FileManager {
    private let permissionsUpdated: Bool
    private let fileExists: Bool
    
    init(fileExists: Bool = true, permissionsUpdated: Bool = true) {
        self.fileExists = fileExists
        self.permissionsUpdated = permissionsUpdated
    }
    
    override func attributesOfItem(atPath path: String) throws -> [FileAttributeKey : Any] {
        if fileExists && permissionsUpdated {
            return [FileAttributeKey.ownerAccountName: NSUserName(), FileAttributeKey.groupOwnerAccountName: "staff"]
        }
        
        return [FileAttributeKey.ownerAccountName: "otherUser", FileAttributeKey.groupOwnerAccountName: "otherUserGroup"]
    }
}
