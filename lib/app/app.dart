import 'package:memegeneraterappusingstacked/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:memegeneraterappusingstacked/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:memegeneraterappusingstacked/ui/views/home/home_view.dart';
import 'package:memegeneraterappusingstacked/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:memegeneraterappusingstacked/services/memegenerationservice_service.dart';
import 'package:memegeneraterappusingstacked/ui/views/memeview/memeview_view.dart';
import 'package:memegeneraterappusingstacked/services/fetchmemesdata_service.dart';
import 'package:memegeneraterappusingstacked/services/admob_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: MemeviewView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: MemegenerationserviceService),
    LazySingleton(classType: FetchmemesdataService),
    LazySingleton(classType: AdmobService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
