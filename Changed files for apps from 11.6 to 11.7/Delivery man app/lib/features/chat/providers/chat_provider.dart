

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resturant_delivery_boy/common/models/api_response_model.dart';
import 'package:resturant_delivery_boy/features/chat/domain/models/chat_model.dart';
import 'package:resturant_delivery_boy/features/chat/domain/reposotories/chat_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker_helper.dart';
import 'package:http/http.dart' as http;
import 'package:resturant_delivery_boy/helper/show_custom_snackbar_helper.dart';
import 'package:resturant_delivery_boy/helper/file_validation_helper.dart';
import 'package:resturant_delivery_boy/main.dart';
class ChatProvider with ChangeNotifier {
  final ChatRepo? chatRepo;
  ChatProvider({required this.chatRepo});

  List<Messages>?  _messages;
  bool _isSendButtonActive = false;
  List <XFile>? _imageFile;
  List <XFile>_chatImage = [];
  bool _isLoading= false;

  List<Messages>? get messages => _messages;
  bool get isSendButtonActive => _isSendButtonActive;
  List <XFile>? get imageFile => _imageFile;
  List<XFile> get chatImage => _chatImage;
  bool get isLoading => _isLoading;

  Future<void> getChatMessages (int? orderId) async {
    ApiResponseModel apiResponse = await chatRepo!.getMessage(orderId,1);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _messages = [];
      _messages?.addAll(ChatModel.fromJson(apiResponse.response!.data).messages!);
    } else {
      _messages = [];
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void pickImage(bool isRemove) async {
    if(isRemove) {
      _imageFile = [];
      _chatImage = [];
    }else {
      _imageFile = await FileValidationHelper.validateAndPickMultipleImages(
        context: Get.context!,
      );
      if (_imageFile!.isNotEmpty) {
        _chatImage.addAll(_imageFile!);
      }
    }
    _isSendButtonActive = true;
    notifyListeners();
  }
  void removeImage(int index){
    chatImage.removeAt(index);
    notifyListeners();
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  Future<http.StreamedResponse> sendMessage(String message, List<XFile> file, int? orderId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await chatRepo!.sendMessage(message, file, orderId);
    if (response.statusCode == 200) {
      _imageFile = [];
      _chatImage = [];
      file =[];
      getChatMessages(orderId);
      _isLoading= false;
    } else {
      final String error = await ApiCheckerHelper.getStreamedResponseError(response);
      showCustomSnackBarHelper(error, isError: true);

    }
    _imageFile = [];
    _isLoading= false;
    notifyListeners();
    return response;
  }

}
