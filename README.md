# OnionKit for iOS

Objective-C Tor Wrapper Framework for iOS. **Don't actually use this yet.** This project is based on iOS-OnionBrowser and Tor.framework.

To clone:

    $ git clone git://github.com/ChatSecure/OnionKit.git
    $ cd OnionKit        
    $ git submodule update --init --recursive
   
This will clone all of the required dependencies into the Submodules directory.

## Build

Build OpenSSL and libevent static libaries for iOS.

    $ cd Submodules/iOS-OnionBrowser/
    $ bash build-libssl.sh
    $ bash build-libevent.sh
    $ cd ../../
    $ bash build-tor.sh

## Usage

To include in a standard project:

1. Drag the `OnionKit.xcodeproj` file into your project files.
2. Go to your target's Build Phases tab
3. Add `OnionKit` as a Target Dependency
4. Add `libOnionKit.a` to your "Link Binary with Libraries" step.
	a. Include the libraries found in `OnionKit/Submodules/iOS-OnionBrowser/dependencies/lib`.