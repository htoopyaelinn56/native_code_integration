pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

pub fn greet() -> String {
    "Hello From Rust! 🦀".to_string()
}

pub async fn get_random() -> String {
    let body = reqwest::get("https://bored-api.appbrewery.com/random")
        .await
        .unwrap()
        .text()
        .await;

    let body = body.unwrap();
    body
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

    #[tokio::test]
    async fn greet_async_works() {
        let random_data = get_random().await;
        println!("{}", random_data);
    }
}
