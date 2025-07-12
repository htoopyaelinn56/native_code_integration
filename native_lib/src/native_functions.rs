pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

pub fn greet() -> String {
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
