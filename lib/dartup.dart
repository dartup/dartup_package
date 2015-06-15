/// Helper library for writing Dart server application running on the Dartup platform.
///
/// For the alpha period this library is required. To give me greater flexibility.
/// Later this will be more of convenience helper library to get a quick start on Dartup
/// or unlock some hidden features.
library dartup;

import 'dart:async';
import 'dart:io';

/// returns true this code is running on Dartup.
bool onDartup() => Platform.environment['DARTUP'] == '1';

/// Returns the Dartup port for http traffic or [defaultPort] depending on environment.
///
/// Its main use case is to have a port that works both in local development and running at the Dartup shared host.
/// The defaultPort can also be an function that will be called if you have complex default values.
///
/// Simple example:
///
///     httpPort(); //8080 or some Dartup port
///     httpPort(8000); //8000 or some Dartup port
///
/// More complex example when you already many environments with different ports:
///
///     httpPort((){
///       if(isProduction()){
///         return 80;
///       }else{
///         return 8080;
///       }
///     });
///
int httpPort([defaultPort = 8080]){
  if(onDartup()){
    return int.parse(Platform.environment['DARTUP_PORT']);
  }
  if(defaultPort is Function) {
    return defaultPort();
  }
  return defaultPort;
}

/// Returns the Dartup listening address for http traffic or [defaultAddress] depending on environment.
///
/// Its main use case is to have a address that works both in local development and running at the Dartup shared host.
/// The defaultAddress can also be an function that will be called if you have complex default values.
///
/// Simple example:
///
///     httpAddress(); //127.0.0.1 or some Dartup port
///     httpAddress('0.0.0.0'); //0.0.0.0 or some Dartup port
///
/// More complex example when you already many environments with different ports:
///
///     httpAddress((){
///       if(isProduction()){
///         return '0.0.0.0';
///       }else{
///         return '127.0.0.1';
///       }
///     });
///
String httpAddress([defaultAddress = '127.0.0.1']){
  if(onDartup()){
    return Platform.environment['DARTUP_ADDRESS'];
  }
  if(defaultAddress is Function) {
    return defaultAddress();
  }
  return defaultAddress;
}

/// A convenience Dartup version of [HttpServer.bind]
///
/// This works like HttpServer.bind excepts that when its running at Dartup it will ignore your arguments and use the
/// values given from the service. So you should pass in the address and port that is correct for local development.
///
/// Se [httpAddress] and [httpPort] for details on how the defaultAddress and defaultPort is handled.
///
/// An example that will work just as well in local development as running on Dartup.
///
///     main(){
///       bind('0.0.0.0', 8000).then((server) {
///         server.listen((HttpRequest request) {
///           request.response.write('Hello, world!');
///           request.response.close();
///         });
///       });
///     }
Future<HttpServer> bind([defaultAddress = '127.0.0.1', defaultPort = 8080]){
  return HttpServer.bind(httpAddress(defaultAddress),httpPort(defaultPort));
}

/// Returns the main domain your application is running under.
///
/// This works only when running at Dartup and will return an empty string otherwise.
/// And will only return the main domain configured to this project not other alias names.
///
/// Example:
///
///     print('Hello from ' + mainDomain()); // Hello from exsample.dartup.io
String mainDomain(){
  if(onDartup()){
    return Platform.environment['DARTUP_DOMAIN'];
  }
  return '';
}