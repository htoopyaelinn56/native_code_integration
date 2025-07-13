pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

pub fn greet() -> String {
    "Hello From Rust! 🦀".to_string()
}

pub fn get_random() -> String {
    let response = ureq::get("https://bored-api.appbrewery.com/random").call();
    match response {
        Ok(mut result) => {
            let body: String = result
                .body_mut()
                .read_to_string()
                .unwrap_or_else(|_| "No data".to_string());
            body
        }
        Err(e) => e.to_string(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn add_works() {
        assert_eq!(add(3, 5), 8);
    }

    #[test]
    fn greet_works() {
        assert_eq!(greet(), "Hello From Rust!  🦀");
    }

    #[test]
    fn get_random_works() {
        let random_data = get_random();
        println!("{}", random_data);
    }
}
