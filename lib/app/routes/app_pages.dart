import 'package:get/get.dart';
import '../modules/menu/menu_view.dart';
import '../modules/game/game_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.MENU;

  static final routes = [
    GetPage(name: Routes.MENU, page: () => MenuView()),
    GetPage(name: Routes.GAME, page: () => GameView()),
  ];
}
