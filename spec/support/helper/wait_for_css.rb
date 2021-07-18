module WaitForCss
  # cssが表示されるまで待つ
  def wait_for_css_appear(selector, wait_time = 100)
    Timeout.timeout(wait_time) do
      loop until has_css?(selector)
    end
    yield if block_given?
  end
end

RSpec.configure do |config|
  config.include WaitForCss, type: :system
end
