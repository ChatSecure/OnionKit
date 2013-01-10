OnionKit
========

Objective-C Tor Wrapper Framework for iOS

To clone:

    $ git clone git://github.com/ChatSecure/OnionKit.git --recursive
    
Or if you didn't use `--recursive` make sure to do:
    
    $ git submodule init
    $ git submodule update
   
This will clone all of the required dependencies into the Submodules directory.

Usage
--------

To include in a standard project:

1. Drag the `OnionKit.xcodeproj` file into your project files.
2. Go to your target's Build Phases tab
3. Add `OnionKit` as a Target Dependency
	a. If you already include MagicalRecord in your project, add `OnionKit (Core)` instead.
4. Add `libOnionKit.a` to your "Link Binary with Libraries" step.
	a. If you already include MagicalRecord in your project, add `libOnionKit_Core.a` instead.
	b. Include the libraries found in `OnionKit/Submodules/iOS-OnionBrowser/dependencies/lib`.
	c. If you get linker errors when including `libevent.a`, try not including that library. This is the case when linking within ChatSecure.
	
Don't actually use this yet.