import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vision_ai/utils/constants.dart';

class DataServices{
  Future<List<Map<String, dynamic>>> getLanguages()async {
    final url = Uri.parse("${Constants.baseUrl}languages/");
   final response = await http.get(url);
    List<Map<String, dynamic>> loadedColleges = [];
    Map<String,dynamic> result = jsonDecode(response.body);
    result.forEach((key, value) => loadedColleges.add({
      "id": key,
      "name": value,
    }));
  return loadedColleges;
  }


  Future<String> getHashTags(String title)async{
    try{
      final url = Uri.parse("${Constants.baseUrl}content/hash_tag_generator/$title");
      return http.get(url).then((value) => jsonDecode(value.body)["hash_tags"]);
    }
    on HttpException catch(e){
      throw Exception(e.message);
    }
    catch(e){
      throw Exception("Something went wrong")  ;
    }

  }
  Future<String> getDescription(String title)async{
    try{
      final url = Uri.parse("${Constants.baseUrl}content/description_generator/$title");
      return http.get(url).then((value) => jsonDecode(value.body)["description"]);
    }
    on HttpException catch(e){
      throw Exception(e.message);
    }
    catch(e){
      throw Exception("Something went wrong")  ;
    }

  }
  Future<String> getScript(String title,String time)async{
    try{
      final url = Uri.parse("${Constants.baseUrl}content/script_generator/$title/$time");
      return http.get(url).then((value) => jsonDecode(value.body)["script"]);
    }

    on HttpException catch(e){
    throw Exception(e.message);
    }
    catch(e){
    throw Exception("Something went wrong")  ;
    }
  }


}