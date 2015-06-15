A required library for the Dartup alpha. That gives you the runtime configuration to run your service on the Dartup platform.

Quick api overview:
-------------------
Most of these functions have arguments in from of default argument that is used when not running on the Dartup platform.

 - **bool onDartup()** Returns true if running on Dartup
 - **int httpPort(defaultPort)** return port you need listen to get traffic from the proxy.
 - **String httpAddress(defaultAddress)** return ip you need to listen get traffic from the proxy.
 - **Future<HttpServer> bind(defaultAddress,defaultPort)** a convenient Dartup version of HttpServer.bind
 - **String mainDomain()** get the domain you are configured as. Only works if onDartup is true.
 
Quick example:
--------------

    import 'dart:io';
    import 'package:dartup/dartup.dart' as dartup;
    
    main() async{
      HttpServer server = await dartup.bind('localhost',8080);
      server.listen((HttpRequest request){
        if(dartup.onDartup()){
          request.response.write('Hello world from Dartup');
        }else{
          request.response.write('Hello world');
        }
        request.response.close();
      });
    }