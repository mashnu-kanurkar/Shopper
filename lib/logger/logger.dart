import 'package:my_local_market/values/strings.dart';

import 'custom_trace.dart';

class Logger{
  LogLevel _level;

  String _message;

  StackTrace _trace;

  Logger.log(this._level, this._message, this._trace){
    CustomTrace programInfo = CustomTrace(_trace);
    if(_level == LogLevel.DEBUG){
      print("${AppStrings.app_name}/ msg: $_message /Source file: ${programInfo.fileName}, function: ${programInfo.functionName}, caller function: ${programInfo.callerFunctionName}, line: ${programInfo.lineNumber}, column: ${programInfo.columnNumber}");
    }

  }
}

enum LogLevel {
  VERBOSE,
  DEBUG,
  ERROR,
  WARNING,
  INFO
}
