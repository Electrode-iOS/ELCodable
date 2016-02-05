# ELCodable [![Build Status](https://travis-ci.org/Electrode-iOS/ELCodable.svg?branch=master)](https://travis-ci.org/Electrode-iOS/ELCodable)

ELCodable, a data model decoding/encoding framework for Swift.  Inspired by Anviking's Decodable (https://github.com/Anviking/Decodable)

## Introduction

ELCodable provides an easy mechanism by which to encode/decode JSON data into proper swift models w/ data mutability/immutability.  

It provides the following functionality:

* Swift optionals to determine required fields from optional fields.
* An easy to use JSON wrapper.
* Encoding to JSON.
* Decoding from JSON.
* Type conversion, both in model types as well as common forms of JSON, such as NSData, Dictionaries, Arrays, etc.
* Data validation.

## Defining & using your model

```Swift
struct MyModel {
    let myString: String
    let myNumber: UInt
}
```

Once you've defined your model, now extend it such that it works with the decoder.

```Swift
extension MyModel: Decodable {
    static func decode(json: JSON?) throws -> MyModel {
        return try MyModel(
            myString: json ==> "myString",
            myNumber: json ==> "myNumber"
        )
    }
}
```

The above will allow your model to be decoded.  As for triggering decoding, you've got a few options...

The simplest way:
```Swift
let myModel = try? MyModel.decode(json)
```

At this point, myModel will either have a value, or be nil.  If you'd like more information on what caused a failure, you can do this:

```Swift
do {
    // decode the json
    let myModel = try MyModel.decode(json)
    // do something with the model
    doSomething(myModel)
} catch DecodeError.NotFound(let key) {
    print("MyModel couldn't be decoded because \(key) couldn't be found.")
} catch let error {
    // catch all for any errors that may happen.
}
```

Now that we've decoded and done something with our model.  Lets look at how encoding would work.

## Encoding

```Swift
extension MyModel: Encodable {
    func encode() throws -> JSON {
        return try encodeToJSON(
            "myString" <== myString,
            "myNumber" <== myNumber
        )
    }
}
```

Now that you've done this, you can send it to disk wherever else it might need to go.

```Swift
let json = try? myModel.encode()
if let json = json {
    json.data().writeToFile(path)
}
```
}
