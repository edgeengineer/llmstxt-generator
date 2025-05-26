import Testing
@testable import ExampleLibrary

struct DataManagerTests {
    
    @Test func setValue() async {
        let manager = DataManager()
        await manager.setValue("test", forKey: "key1")
        
        let value = await manager.getValue(forKey: "key1") as? String
        #expect(value == "test")
    }
    
    @Test func removeValue() async {
        let manager = DataManager()
        await manager.setValue(42, forKey: "number")
        
        let removed = await manager.removeValue(forKey: "number") as? Int
        #expect(removed == 42)
        
        let afterRemoval = await manager.getValue(forKey: "number")
        #expect(afterRemoval == nil)
    }
    
    @Test func storageCount() async {
        let manager = DataManager()
        
        #expect(await manager.getStorageCount() == 0)
        
        await manager.setValue("value1", forKey: "key1")
        await manager.setValue("value2", forKey: "key2")
        
        #expect(await manager.getStorageCount() == 2)
    }
    
    @Test func accessCount() async {
        let manager = DataManager()
        
        let initialCount = await manager.getAccessCount()
        await manager.setValue("test", forKey: "key")
        _ = await manager.getValue(forKey: "key")
        
        let finalCount = await manager.getAccessCount()
        #expect(finalCount == initialCount + 2)
    }
    
    @Test func clearAll() async {
        let manager = DataManager()
        
        await manager.setValue("value1", forKey: "key1")
        await manager.setValue("value2", forKey: "key2")
        
        #expect(await manager.getStorageCount() == 2)
        
        await manager.clearAll()
        
        #expect(await manager.getStorageCount() == 0)
    }
}