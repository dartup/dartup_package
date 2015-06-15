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