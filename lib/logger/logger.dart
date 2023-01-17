import 'package:my_local_market/values/strings.dart';

import 'custom_trace.dart';

class Logger{

  static final Map<String, Logger> _cache = <String, Logger>{};

  LogLevel _logLevel = LogLevel.OFF;

  String key;

  factory Logger(){
    if(_cache.isNotEmpty){
      return _cache["_loggerKey"]!;
    }else{
      final logger = Logger._internal("_loggerKey");
      _cache["_loggerKey"] = logger;
      return logger;
    }
  }
  Logger._internal(this.key);


  void setLogLevel(LogLevel logLevel){
    _logLevel = logLevel;
  }

  void log(LogLevel level, String message, StackTrace? trace){
    if(_logLevel == LogLevel.OFF){
      return;
    }
    if(level.index <= _logLevel.index){
      if(trace == null){
        print("${AppStrings.app_name}/ msg: $message");
      }else{
        CustomTrace programInfo = CustomTrace(trace);
        print("${AppStrings.app_name}/ msg: $message /Source file: ${programInfo.fileName}, function: ${programInfo.functionName}, caller function: ${programInfo.callerFunctionName}, line: ${programInfo.lineNumber}, column: ${programInfo.columnNumber}");
      }
    }

  }

}

enum LogLevel {
  VERBOSE,
  DEBUG,
  ERROR,
  WARNING,
  INFO,
  OFF
}
