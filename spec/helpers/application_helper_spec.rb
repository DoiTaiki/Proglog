require 'rails_helper'

describe ApplicationHelper do
  describe "time_format" do
    let(:current_time) { Time.now }

    context "arguement's data type is Time" do
      it "displays time which is arranged format" do
        expect(time_format current_time).to eq Time.now.strftime("%Y年%m月%d日-%H:%M")
      end
    end

    context "arguement's data type is wrong" do
      let(:current_time) { "a" }
      it "raises NoMethodError" do
        expect { time_format current_time }.to raise_error(NoMethodError)
      end
    end

    context "arguement's data is blank" do
      let(:current_time) { "" }
      it "raises NoMethodError" do
        expect { time_format current_time }.to raise_error NoMethodError
      end
    end

    context "arguement's data is nil" do
      let(:current_time) { nil }
      it "raises NoMethodError" do
        expect { time_format current_time }.to raise_error NoMethodError
      end
    end

  end
end
