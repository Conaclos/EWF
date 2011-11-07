Official project site for Eiffel Web Framework:
* http://eiffel-world.github.com/Eiffel-Web-Framework/

For more information please have a look at the related wiki:
* https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki

How to get the source code?
---------------------------

* git clone https://github.com/Eiffel-World/Eiffel-Web-Framework.git
* cd Eiffel-Web-Framework
* git submodule update --init
* git submodule foreach --recursive git checkout master

Or using git version >= 1.6.5
* git clone --recursive https://github.com/Eiffel-World/Eiffel-Web-Framework.git

* And to build the required and related Clibs
** cd ext/ise_library/curl
** geant compile

Overview
--------

* library/server/ewsgi: Eiffel Web Server Gateway Interface
* library/server/ewsgi/connectors: various web server connectors for EWSGI
* library/server/libfcgi: Wrapper for libfcgi SDK

* library/server/request/router: URL dispatching/routing based on uri, uri_template, or custom.
* library/server/request/rest: experimental: RESTful library to help building RESTful services

* library/protocol/http: HTTP related classes, constants for status code, content types, ...
* library/protocol/uri_template: URI Template library (parsing and expander)

* library/error: very simple/basic library to handle error
* library/text/encoder: Various simpler encoder: base64, url-encoder, xml entities, html entities

For more information please have a look at the related wiki:
* https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki
