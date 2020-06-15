class ParseJsonBody {
  String message;
  String statuscode;
  String data;

  //解析json
  factory ParseJsonBody.fromJson(Map<String, dynamic> json) {
    return ParseJsonBody(message: json['message'], statuscode: json['statuscode'], data: json['data']);
  }

  //返回消息体
  ParseJsonBody({
    this.message,
    this.statuscode,
    this.data,
  });
}