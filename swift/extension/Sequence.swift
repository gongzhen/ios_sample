import Foundation

// http://machinethink.net/blog/mixins-and-traits-in-swift-2.0/
// Create your own Enumerable protocol like Sequence and IteratorProtocol
protocol Enumerable {
	associatedtype Element
	func each(block:(Self.Element) -> Void) 
}

extension Enumerable {
	func dropIf(predicate:(Self.Element) -> Bool) -> [Self.Element] {
		var result = [Element]
		each{ item in if predicate(item) == false {
			result.append(item)
		}}
		return result
	}

	func dropWhile(predicate:(Self.Element) -> Bool) -> [Self.Element] {
		return [Element]()
	}

	func findAll(predicate:(Self.Element) -> Bool) -> [Self.Element] {
		return [Element]()
	}

}	

struct Family:Enumerable {
    var name = "Smith"
    var father = "Bob"
    var mother = "Alice"
    var child = "Carol"

    func each(block:(String) -> Void) {
    	for i in 0...2 {
    		switch i {
    			case 0: block("\(father) \(name)")
            	case 1: block("\(mother) \(name)")
            	case 2: block("\(child) \(name)")
            	default: break    	
    		}
    	}
    }
}

let f = Family()
let withoutBob = f.dropIf { (p:String) -> Bool in
    p.hasPrefix("Bob")
}

// https://stackoverflow.com/questions/31730127/add-for-in-support-to-a-class-in-swift-2
// http://machinethink.net/blog/mixins-and-traits-in-swift-2.0/
// Using Swift built-in Iterator protocol
extension IteratorProtocol {
	mutating func dropIf(predicate: (Self.Element) -> Bool) -> [self.Element] {
		var result = [Element]()
		while true {
			if let item = next() {
				if !predicate(item) {
					result.append(item)
				}
			} else {
				return result
			}
		}
	}
}

struct FamilySequence: Sequence {
    var name = "Smith"
    var father = "Bob"
    var mother = "Alice"
    var child = "Carol"	

    typealias Generator = AnyIterator<String>

    func makeIterator() -> Generator {
    	var i = 0
    	return AnyIterator.init({
    		switch i {
    		case 0:
			i = i + 1
			return "\(self.father) \(self.name)"
			case 1:
			i = i + 1
			return "\(self.mother) \(self.name)"
			case 2:
			i = i + 1
			return "\(self.child) \(self.name)"
			default:
			return nil     				
    		}	
    	})
    }
}

let fs = FamilySequence()

for x in fs {
   print(x)
}

var g = fs.makeIterator()
let withoutBobAgain = g.dropIf { p in p.hasPrefix("Bob") }
print(withoutBobAgain)

// Create your own class sequence and iterator protocol

// https://stackoverflow.com/questions/31730127/add-for-in-support-to-a-class-in-swift-2
// http://machinethink.net/blog/mixins-and-traits-in-swift-2.0/

class FamilyIterator<Element>: IteratorProtocol {
	typealias Element = String
	var familyList:[String]?
	var startIndex = 0

	init(familyList:[String]) {
		self.familyList = familyList
	}

	func next() -> Element? {
		guard let list = self.familyList else {return nil}

		guard startIndex < list.count else { return nil }

		let element = list[startIndex]
		startIndex = startIndex + 1

		return element
	}
}

class FamilySequence: Sequence {

    var name = "Smith"
    var father = "Bob"
    var mother = "Alice"
    var child = "Carol"
    
    var familyList:[String]?	

	init() {
		self.familyList = ["\(self.father) \(self.name)", "\(self.mother) \(self.name)", "\(self.child) \(self.name)"]
	}

    func makeIterator() -> FamilyIterator<String> {
        return FamilyIterator(familyList: self.familyList!)
    }	
}

let fs2 = FamilySequence()

for x in fs2 {
    print(x)
}

print("Hello, World!")







