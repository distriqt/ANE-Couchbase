
## Supported

When using the extension you should always check whether the extension functionality
is supported on the current platform and disable the functionality in your application
as appropriate. You can use the `Couchbase.isSupported` flag to check whether the 
extension is supported on the current platform.

```as3
if (Couchbase.isSupported)
{
    // use extension functionality here
}
```


## Setup Couchbase

The first call you must make is to setup the Couchbase manager by calling `setup()`.

```as3
Couchbase.service.setup();
```

This call initialises the extension and sets up the Couchbase manager. You must do 
this before calling any other functionality of the extension.




