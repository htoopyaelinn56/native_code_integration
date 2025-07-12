package com.hm.jetpackcomposeplusrust

object NativeLib {
    init {
        System.loadLibrary("jni_bridge")
    }

    private external fun addFfi(left: Long, right: Long): Long
    private external fun greetFfi(): String

    // wrapper functions
    fun add(left: Long, right: Long) = addFfi(left, right)
    fun greet() = greetFfi()
}