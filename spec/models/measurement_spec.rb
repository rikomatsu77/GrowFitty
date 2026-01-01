require "rails_helper"

RSpec.describe Measurement, type: :model do
  describe "associations" do
    it { should belong_to(:child) }
  end

  describe "enums" do
    it "measurement_typeにheightとweightが定義されている" do
      expect(Measurement.measurement_types.keys).to contain_exactly("height", "weight")
    end
  end

  describe "validations" do
    let(:measurement) { build(:measurement) }

    it "全ての値が正しければ有効" do
      expect(measurement).to be_valid
    end

    it "measurement_typeがなければ無効" do
      measurement.measurement_type = nil
      expect(measurement).not_to be_valid
      expect(measurement.errors[:measurement_type]).to be_present
    end

    context "measured_onがある場合" do
      it "valueがなければ無効" do
        measurement.value = nil
        expect(measurement).not_to be_valid
        expect(measurement.errors[:value]).to be_present
      end

      it "valueが数値でなければ無効" do
        measurement.value = "abc"
        expect(measurement).not_to be_valid
        expect(measurement.errors[:value]).to be_present
      end
    end

    context "valueがある場合" do
      it "measured_onがなければ無効" do
        measurement.measured_on = nil
        expect(measurement).not_to be_valid
        expect(measurement.errors[:measured_on]).to be_present
      end
    end
  end
end
