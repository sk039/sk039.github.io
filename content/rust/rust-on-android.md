+++
title = "在安卓中调用 rust 动态库"
date = 2022-08-28
[taxonomies]
categories = ["rust"]
tags = ["安卓", "android", "jni"]
+++

## 项目介绍

项目链接：https://github.com/martinwairegi/rustonandroid

文件结构：

```bash
├── android          # 安卓相关代码
├── rust	     # rust 相关代码，调用 libgmp 库实现功能
├── build-all.sh     # 全局构建脚本
├── build-apk.sh     # 安卓 apk 编译构建脚本
├── build-librpn.sh  # rust 动态库构建脚本
└── build-libgmp.sh  # libgmp 构建脚本
```

***注意：***此项目代码使用 NDK-r23+ 无法编译成功，需要打补丁（见文末）。

主要因为以下两个原因：

1. NDK r23 之后 rust 编译报错 `ld: error: unable to find library -lgcc`

   解决方法见：https://github.com/rust-lang/rust/pull/85806#issuecomment-1096266946

2. 项目编码错误

   类名、函数名错误；编译脚本宏路径、名称错误。

项目构建：

```bash
$ export ANDROID_SDK_ROOT=/opt/Android/Sdk/
$ export ANDROID_NDK_ROOT=/opt/Android/Sdk/ndk/23.1.7779620
$ export ANDROID_API=29
$ ./build-all.sh
```

## 知识拓展

rust 库编译可以使用 cargo-ndk 工具。

https://github.com/bbqsrc/cargo-ndk

## 补丁

``` diff
--- a/build-libgmp.sh
+++ b/build-libgmp.sh
@@ -86,34 +86,34 @@ fi
 # If the build directory does not exist, create it.
 if [[ ! -d "${TARGET_DIR}" ]]; then
 	# If we don't have a local copy of the libgmp archive, download it.
-	if [[ ! -f "${BUILD_DIR}/gmp-${VERSION}.tar.lz" ]]; then
+	if [[ ! -f "${BUILD_DIR}/gmp-${VERSION}.tar.xz" ]]; then
 		cd "${BUILD_DIR}"
-		curl --remote-name "https://gmplib.org/download/gmp/gmp-${VERSION}.tar.lz"
+		curl --remote-name "https://gmplib.org/download/gmp/gmp-${VERSION}.tar.xz"
 	fi
 
 	# Extract the libgmp archive.
 	mkdir -p "${BUILD_DIR}/${ARCH}/${BUILD_MODE}"
 	cd "${BUILD_DIR}/${ARCH}/${BUILD_MODE}"
-	tar lxf "${BUILD_DIR}/gmp-${VERSION}.tar.lz"
+	tar xf "${BUILD_DIR}/gmp-${VERSION}.tar.xz"
 fi
 
 # Set up the NDK tools for cross-compiling.
 TOOLCHAIN="${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/"
 if [[ "${ARCH}" == "armv7" ]]; then
 	HOST="armv7a-linux-androideabi"
-	TOOL_PREFIX="${TOOLCHAIN}/bin/arm-linux-androideabi"
+	TOOL_PREFIX="${TOOLCHAIN}/bin/"
 else
 	HOST="${ARCH}-linux-android"
-	TOOL_PREFIX="${TOOLCHAIN}/bin/${HOST}"
+	TOOL_PREFIX="${TOOLCHAIN}/bin/"
 fi
 COMPILER_PREFIX="${TOOLCHAIN}/bin/${HOST}${ANDROID_API}"
 
-export AR="${TOOL_PREFIX}-ar"
-export AS="${TOOL_PREFIX}-as"
+export AR="${TOOL_PREFIX}llvm-ar"
+export AS="${TOOL_PREFIX}llvm-as"
 export CC="${COMPILER_PREFIX}-clang"
-export LD="${TOOL_PREFIX}-ld"
-export RANLIB="${TOOL_PREFIX}-ranlib"
-export STRIP="${TOOL_PREFIX}-strip"
+export LD="${TOOL_PREFIX}ld"
+export RANLIB="${TOOL_PREFIX}llvm-ranlib"
+export STRIP="${TOOL_PREFIX}llvm-strip"
 
 # Set up compiler flags.
 if [[ "${BUILD_MODE}" == "release" ]]; then
diff --git a/build-librpn.sh b/build-librpn.sh
old mode 100644
new mode 100755
index a4730a4..509ba9a
--- a/build-librpn.sh
+++ b/build-librpn.sh
@@ -88,12 +88,12 @@ cd "$(dirname "${BASH_SOURCE[0]}")/rust/"
 TOOLCHAIN="${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64"
 if [[ "${ARCH}" == "armv7" ]]; then
 	HOST="armv7a-linux-androideabi"
-	TOOL_PREFIX="${TOOLCHAIN}/bin/arm-linux-androideabi"
+	TOOL_PREFIX="${TOOLCHAIN}/bin/"
 
 	RUST_TARGET="armv7-linux-androideabi"
 else
 	HOST="${ARCH}-linux-android"
-	TOOL_PREFIX="${TOOLCHAIN}/bin/${HOST}"
+	TOOL_PREFIX="${TOOLCHAIN}/bin/"
 
 	RUST_TARGET="${ARCH}-linux-android"
 fi
@@ -111,7 +111,7 @@ fi
 #
 # The RUSTFLAGS variable sets up the linking path (tells rustc where to look for dependencies).
 env \
-	"AR_${RUST_TARGET}=${TOOL_PREFIX}-ar" \
+	"AR_${RUST_TARGET}=${TOOL_PREFIX}llvm-ar" \
 	"CC_${RUST_TARGET}=${COMPILER_PREFIX}-clang" \
 	"CARGO_TARGET_${RUST_TARGET_CAPS}_LINKER=${COMPILER_PREFIX}-clang" \
 	"RUSTFLAGS=-L ${LIBS_DIR}" \
diff --git a/build/libgmp/gmp-6.2.1.tar.lz b/build/libgmp/gmp-6.2.1.tar.lz
deleted file mode 100644
index f02b412..0000000
Binary files a/build/libgmp/gmp-6.2.1.tar.lz and /dev/null differ
diff --git a/rust/src/android.rs b/rust/src/android.rs
index 68d3883..a08efd0 100644
--- a/rust/src/android.rs
+++ b/rust/src/android.rs
@@ -54,7 +54,7 @@ where
 	 * and hope for the best.
 	 */
 	let class = env
-		.find_class("pl/svgames/blog/RustOnAndroid/Result")
+		.find_class("pl/martin/blog/RustOnAndroid/Result")
 		.unwrap();
 	let args: [JValue<'e>; 2] = [
 		JValue::Bool(u8::from(is_ok)),
@@ -71,7 +71,7 @@ fn rpn_wrapper(env: &JNIEnv, expression: JString) -> Result<BigNum> {
 }
 
 #[no_mangle]
-pub extern "system" fn Java_pl_svgames_blog_RustOnAndroid_RpnCalculator_rpn<
+pub extern "system" fn Java_pl_martin_blog_RustOnAndroid_RpnCalculator_rpn<
 	'e,
 >(
 	env: JNIEnv<'e>,
```
