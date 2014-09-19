# [OnionKit](https://github.com/chatsecure/onionkit)
[![Build Status](https://travis-ci.org/ChatSecure/OnionKit.svg)](https://travis-ci.org/ChatSecure/OnionKit)

Objective-C Tor Wrapper Framework for iOS. **Don't actually use this yet.** This project is based on [iOS-OnionBrowser](https://github.com/mtigas/iOS-OnionBrowser) and [Tor.framework](https://github.com/hivewallet/Tor.framework).

To clone:

    $ git clone git://github.com/ChatSecure/OnionKit.git
    $ cd OnionKit        
    $ git submodule update --init --recursive
   
This will clone all of the required dependencies into the Submodules directory.

### Dependency Versions

* [OpenSSL](https://www.openssl.org) v1.0.1i - 06-Aug-2014
* [libevent](http://libevent.org) v2.0.21-stable - 2012-11-18
* [Tor](https://www.torproject.org) v0.2.4.21 - Mar 1 2014

## Build

Build OpenSSL, libevent and libtor static libaries for iOS.

    $ bash build-libssl.sh
    $ bash build-libevent.sh
    $ bash build-libtor.sh

## Usage

Although I haven't submitted the podspec yet, you can try to use `OnionKit.podspec` in the meantime.

    pod 'OnionKit', :git => 'https://github.com/ChatSecure/OnionKit.git'

## License

The code for this project is dual licensed under the [LGPLv2.1+](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt) and [MPL 2.0](http://www.mozilla.org/MPL/2.0/). The required dependencies are under terms of seperate licenses. More information is available in the [LICENSE](https://github.com/ChatSecure/OnionKit/blob/master/LICENSE) file.