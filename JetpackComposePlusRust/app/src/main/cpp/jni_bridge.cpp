#include <jni.h>
#include <string>
#include <dlfcn.h>
#include <android/log.h>

#define LOG_TAG "JNI_Bridge"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

// Function pointer types for your Rust FFI functions
typedef uint64_t (*AddFfiFunc)(uint64_t, uint64_t);

typedef char *(*GreetFfiFunc)();

typedef char *(*GetRandomFfiFunc)();

// Global variables to hold function pointers
static AddFfiFunc rust_add_ffi = nullptr;
static GreetFfiFunc rust_greet_ffi = nullptr;
static GetRandomFfiFunc rust_get_random_ffi = nullptr;
static void *rust_lib_handle = nullptr;

// Load the Rust library and get function pointers
bool loadRustLibrary() {
    if (rust_lib_handle != nullptr) {
        return true; // Already loaded
    }

    // Load your existing Rust library
    rust_lib_handle = dlopen("libnative_lib.so", RTLD_LAZY);
    if (!rust_lib_handle) {
        LOGE("Failed to load libnative_lib.so: %s", dlerror());
        return false;
    }

    // Get function pointers
    rust_add_ffi = (AddFfiFunc) dlsym(rust_lib_handle, "add_ffi");
    if (!rust_add_ffi) {
        LOGE("Failed to find add_ffi function: %s", dlerror());
        dlclose(rust_lib_handle);
        rust_lib_handle = nullptr;
        return false;
    }

    rust_greet_ffi = (GreetFfiFunc) dlsym(rust_lib_handle, "greet_ffi");
    if (!rust_greet_ffi) {
        LOGE("Failed to find greet_ffi function: %s", dlerror());
        dlclose(rust_lib_handle);
        rust_lib_handle = nullptr;
        return false;
    }

    rust_get_random_ffi = (GetRandomFfiFunc) dlsym(rust_lib_handle, "get_random_ffi");
    if (!rust_get_random_ffi) {
        LOGE("Failed to find get_random_ffi function: %s", dlerror());
        dlclose(rust_lib_handle);
        rust_lib_handle = nullptr;
        return false;
    }

    LOGI("Successfully loaded Rust library and functions");
    return true;
}

// JNI function called when library is loaded
extern "C" JNIEXPORT jint

JNICALL
JNI_OnLoad(JavaVM *vm, void *reserved) {
    JNIEnv *env;
    if (vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6) != JNI_OK) {
        return JNI_ERR;
    }

    if (!loadRustLibrary()) {
        LOGE("Failed to load Rust library in JNI_OnLoad");
        return JNI_ERR;
    }

    return JNI_VERSION_1_6;
}

// JNI function called when library is unloaded
extern "C" JNIEXPORT void JNICALL
JNI_OnUnload(JavaVM
*vm,
void *reserved
) {
if (rust_lib_handle) {
dlclose(rust_lib_handle);
rust_lib_handle = nullptr;
rust_add_ffi = nullptr;
rust_greet_ffi = nullptr;
rust_get_random_ffi = nullptr;
}
}

// JNI wrapper for add_ffi
extern "C" JNIEXPORT jlong

JNICALL
Java_com_hm_jetpackcomposeplusrust_NativeLib_addFfi(JNIEnv *env, jclass clazz, jlong left,
                                                    jlong right) {
    if (!rust_add_ffi) {
        LOGE("rust_add_ffi function pointer is null");
        return 0;
    }

    uint64_t result = rust_add_ffi(static_cast<uint64_t>(left), static_cast<uint64_t>(right));
    return static_cast<jlong>(result);
}

// JNI wrapper for greet_ffi
extern "C" JNIEXPORT jstring

JNICALL
Java_com_hm_jetpackcomposeplusrust_NativeLib_greetFfi(JNIEnv *env, jclass clazz) {
    if (!rust_greet_ffi) {
        LOGE("rust_greet_ffi function pointer is null");
        return env->NewStringUTF("Error: Rust function not loaded");
    }

    char *rust_string = rust_greet_ffi();
    if (!rust_string) {
        LOGE("rust_greet_ffi returned null");
        return env->NewStringUTF("Error: Rust function returned null");
    }

    jstring result = env->NewStringUTF(rust_string);

    // Important: Free the string returned by Rust
    // This assumes your Rust function allocates with malloc/calloc
    // If it uses different allocation, adjust accordingly
    free(rust_string);

    return result;
}

// JNI wrapper for get_random_ffi
extern "C" JNIEXPORT jstring JNICALL
Java_com_hm_jetpackcomposeplusrust_NativeLib_getRandomFfi(JNIEnv *env, jclass clazz) {
    if (!rust_get_random_ffi) {
        LOGE("rust_get_random_ffi function pointer is null");
        return env->NewStringUTF("Error: Rust function not loaded");
    }
    char *rust_string = rust_get_random_ffi();
    if (!rust_string) {
        LOGE("rust_get_random_ffi returned null");
        return env->NewStringUTF("Error: Rust function returned null");
    }
    jstring result = env->NewStringUTF(rust_string);
    free(rust_string);
    return result;
}
