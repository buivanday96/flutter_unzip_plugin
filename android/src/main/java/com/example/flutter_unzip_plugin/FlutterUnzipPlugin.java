package com.example.flutter_unzip_plugin;

import androidx.annotation.NonNull;

import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.progress.ProgressMonitor;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import static net.lingala.zip4j.progress.ProgressMonitor.State.BUSY;


/** FlutterUnzipPlugin */
public class FlutterUnzipPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private FlutterPluginBinding pluginBinding;
  private static final  String LOG_TAG = "FlutterArchivePlugin";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_unzip_plugin");
    channel.setMethodCallHandler(this);

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("unzip")) {
      Log.d("MyZipDecoder", "Starting v0.02...");
      String zipPath = call.argument("zipPath");
      String extractPath = call.argument("extractPath");

      if (zipPath != null){
        ZipFile zipFile = new ZipFile(zipPath);
        zipFile.setRunInThread(true);

        try {
          assert extractPath != null;
          zipFile.extractAll(extractPath);
        } catch (ZipException e) {
          e.printStackTrace();
        }


        ProgressMonitor mon = zipFile.getProgressMonitor();
        while (mon.getState() == BUSY) {
          System.out.println(zipFile.getProgressMonitor().getPercentDone());
          try {
            Thread.sleep(10);
          } catch (InterruptedException e) {
            throw new RuntimeException(e);
          }

          if(mon.getResult() == ProgressMonitor.Result.SUCCESS){
            result.success(true);
            break;
          }
        }
      }

    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
