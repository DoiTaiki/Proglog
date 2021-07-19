module WaitForCss
  # cssが表示されるまで待つ
  def wait_for_css_appear(selector, wait_time = Capybara.default_max_wait_time)
    Timeout.timeout(wait_time) do
      loop until has_css?(selector)
    end
    yield if block_given?
  end

  # cssが表示されなくなるまで待つ
  def wait_for_css_disappear(selector, wait_time = Capybara.default_max_wait_time)
    Timeout.timeout(wait_time) do
      loop until has_no_css?(selector)
    end
    yield if block_given?
  end
end

RSpec.configure do |config|
  config.include WaitForCss, type: :system
end

# def wait_for_element(class_selector)
#   options = ::Selenium::WebDriver::Chrome::Options.new
#
#   options.add_argument("--headless")
#   options.add_argument("--no-sandbox")
#   options.add_argument("--disable-dev-shm-usage")
#   options.add_argument("--window-size=1400,1400")
#   driver = Selenium::WebDriver.for :chrome, options: options
#   driver.get user_url(user)
#   wait = Selenium::WebDriver::Wait.new(:timeout => 10)
#   ele = wait.until { driver.find_element(class: class_selector).displayed?}
# end
