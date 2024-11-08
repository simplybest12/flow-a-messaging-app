import 'package:get/get.dart';

class EmojiController extends GetxController{
  final RxBool emoji= false.obs;

  void changeVisibility(emojiValue){
    emoji.value = !emojiValue;
  }
}