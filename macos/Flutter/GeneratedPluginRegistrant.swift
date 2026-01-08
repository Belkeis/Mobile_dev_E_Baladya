//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

<<<<<<< HEAD
import firebase_core
import firebase_messaging
=======
import file_picker
import firebase_core
import firebase_storage
>>>>>>> kaouter
import path_provider_foundation
import shared_preferences_foundation
import sqflite_darwin
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
<<<<<<< HEAD
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
  FLTFirebaseMessagingPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseMessagingPlugin"))
=======
  FilePickerPlugin.register(with: registry.registrar(forPlugin: "FilePickerPlugin"))
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
  FLTFirebaseStoragePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseStoragePlugin"))
>>>>>>> kaouter
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
}
