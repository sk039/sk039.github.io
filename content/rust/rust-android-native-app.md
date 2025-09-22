+++
title = "使用 Rust 构建原生安卓应用（NDK、Vulkan）"
date = 2022-08-28
[taxonomies]
categories = ["rust"]
tags = ["ndk", "vulkan"]
+++

## 项目介绍

https://github.com/atkurtul/AndroidVulkanTriangle.git

***注意：*** 运行此项目需要打上文末补丁。

主要修改：

1. rust 动态库构建改用 cargo-ndk

2. 去除 Vulkan Validation Layer 相关函数调用

   因为新版本 NDK 已不集成相关二进制 so 文件，此功能是用来调试，去除它不影响项目演示。

   Vulkan Tutorial 04 理解Validation layers：

   https://www.cnblogs.com/heitao/p/6903297.html

构建方法：

```bash
# 安装 apk 构建依赖
$ sudo apt install aapt zipalign

# 编译 rust 动态库
$ ./build.sh

# 构建 apk
$ ./package.sh
```

## 补丁

```diff
diff --git a/build.sh b/build.sh
index 8fa5923..fd3918e 100755
--- a/build.sh
+++ b/build.sh
@@ -1,2 +1,3 @@
-cargo build --target x86_64-linux-android --release
-#cargo build --target aarch64-linux-android --release
\ No newline at end of file
+#cargo build --target x86_64-linux-android --release
+CARGO_ENCODED_RUSTFLAGS="-landroid" cargo ndk -t arm64-v8a -p 30 -o ./jniLibs build
+#cargo build --target aarch64-linux-android --release
diff --git a/package.sh b/package.sh
index bcf457e..6e8d104 100755
--- a/package.sh
+++ b/package.sh
@@ -1,19 +1,21 @@
-ARCH=x86_64
+ARCH=arm64-v8a
 RARCH=$ARCH
 mkdir -p apk/libs/lib/$ARCH
 SONAME=$(grep android.app.lib_name AndroidManifest.xml | grep -oP 'android:value="\K(.*)"')
 OUT="apk/libs/lib/$ARCH/lib"${SONAME%\"}".so"
 
-cp target/$RARCH-linux-android/release/librust_vk_main.so $OUT
+#cp target/$RARCH-linux-android/release/librust_vk_main.so $OUT
+cp jniLibs/arm64-v8a/librust_vk_main.so $OUT
 
-readelf $OUT -d > sym.txt
-readelf $OUT -s >> sym.txt
+#readelf $OUT -d > sym.txt
+#readelf $OUT -s >> sym.txt
 VALIDATION_LAYER=$ANDROID_NDK_HOME/sources/third_party/vulkan/src/build-android/jniLibs/$ARCH/libVkLayer_khronos_validation.so
-cp $VALIDATION_LAYER apk/libs/lib/$ARCH
+#cp $VALIDATION_LAYER apk/libs/lib/$ARCH
 aapt package -f -M AndroidManifest.xml -I $ANDROID_SDK_ROOT/platforms/android-30/android.jar -A assets -F apk/app0.apk apk/libs
 zipalign -f -v 4 apk/app0.apk apk/app.apk
-signapk.sh apk/app.apk
-apkanalyzer files list apk/app.apk
+#signapk.sh apk/app.apk
+jarsigner -verbose -keystore ~/.android/debug.keystore apk/app.apk androiddebugkey
+#apkanalyzer files list apk/app.apk
 #adb uninstall com.native_activity
 #adb install apk/app.apk
 #adb logcat -c
diff --git a/src/build.rs b/src/build.rs
index 26a2f05..ed71e8a 100644
--- a/src/build.rs
+++ b/src/build.rs
@@ -6,10 +6,10 @@ fn main() {
     let target = env::vars().find_map(|(k, v)| if k == "TARGET" { Some(v) } else { None }).unwrap();
     let toolchain = env::vars().find_map(|(k, v)| if k == "ANDROID_TOOLCHAIN" { Some(v) } else { None }).unwrap();
     let compiler = toolchain.clone() + "/bin/" + target.as_str() + "30-clang";
-    let ar =  toolchain + "/bin/" + target.as_str() + "-ar";
+    let ar =  toolchain + "/bin/llvm-ar";
     cc::Build::new()
         .file("src/vk.c")
         .compiler(compiler)
         .archiver(ar)
         .compile("libvk.a");
-}
\ No newline at end of file
+}
diff --git a/src/lib.rs b/src/lib.rs
index 05479d6..b85bbd1 100644
--- a/src/lib.rs
+++ b/src/lib.rs
@@ -32,7 +32,7 @@ fn rust_main(msg: mpsc::Receiver<MainThreadMsg>) {
     a_log("inside rust main".to_owned());
     let instance = create_instance(
         &InstanceCreateInfo::new()
-            .enabled_layer_name(&"VK_LAYER_KHRONOS_validation\0".as_ptr())
+            //.enabled_layer_name(&"VK_LAYER_KHRONOS_validation\0".as_ptr())
             .enabled_extension_names(&[
                 "VK_KHR_surface\0".as_ptr(),
                 "VK_KHR_android_surface\0".as_ptr(),
@@ -45,7 +45,7 @@ fn rust_main(msg: mpsc::Receiver<MainThreadMsg>) {
         .create(
             &DeviceCreateInfo::new()
                 .enabled_extension_name(&"VK_KHR_swapchain\0".as_ptr())
-                .enabled_layer_name(&"VK_LAYER_KHRONOS_validation\0".as_ptr())
+               // .enabled_layer_name(&"VK_LAYER_KHRONOS_validation\0".as_ptr())
                 .queue_create_info(&DeviceQueueCreateInfo::new().queue_priority(&1f32)),
         )
         .unwrap();
```
