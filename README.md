# OnionKit for iOS

Objective-C Tor Wrapper Framework for iOS. **Don't actually use this yet.** This project is based on [iOS-OnionBrowser](https://github.com/mtigas/iOS-OnionBrowser) and [Tor.framework](https://github.com/hivewallet/Tor.framework).

To clone:

    $ git clone git://github.com/ChatSecure/OnionKit.git
    $ cd OnionKit        
    $ git submodule update --init --recursive
   
This will clone all of the required dependencies into the Submodules directory.

## Build

Build OpenSSL, libevent and libtor static libaries for iOS.

    $ bash build-libssl.sh
    $ bash build-libevent.sh
    $ bash build-tor.sh

## Usage

To include in a standard project:

1. Drag the `./dependencies/lib` folder into your project and make sure the static libs are added to your target.
2. In "Search Headers" for your target make to to include `$(SRCROOT)/Submodules/OnionKit/dependencies/include` or something similar.