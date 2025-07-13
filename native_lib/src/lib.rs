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

#[no_mangle]
pub extern "C" fn get_random_ffi() -> *const c_char {
    let result = native_functions::get_random();
    let c_string = CString::new(result).unwrap();
    c_string.into_raw()
}