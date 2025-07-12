mod native_functions;

use std::ffi::{c_char, CString};

#[no_mangle]
pub extern "C" fn add_ffi(left: u64, right: u64) -> u64 {
    native_functions::add(left, right)
}

#[no_mangle]
pub extern "C" fn greet_ffi() -> *mut c_char {
    let s = native_functions::greet();
    CString::new(s).unwrap().into_raw()
}