use std::ffi::{c_char, CString};

#[no_mangle]
pub extern "C" fn add_ffi(left: u64, right: u64) -> u64 {
    add(left, right)
}

#[no_mangle]
pub extern "C" fn greet_ffi() -> *mut c_char {
    let s = greet();
    CString::new(s).unwrap().into_raw()
}

fn add(left: u64, right: u64) -> u64 {
    left + right
}

fn greet() -> String {
    "Hello From Rust! 🦀".to_string()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
