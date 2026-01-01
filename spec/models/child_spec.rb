require 'rails_helper'

RSpec.describe Child, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:measurements).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:birthday) }

    context "birthday validation" do
      it "未来の日付は無効" do
        child = build(:child, birthday: Date.tomorrow)
        expect(child).not_to be_valid
        expect(child.errors[:birthday]).to include("は未来の日付にできません")
      end

      it "過去の日付は有効" do
        child = build(:child, birthday: 3.years.ago)
        expect(child).to be_valid
      end
    end
  end

  describe "instance methods" do
    let(:child) { create(:child) }

    context "#latest_height" do
      it "身長の最新値を返す" do
        create(:measurement, child: child, measurement_type: "height", value: 100, measured_on: 2.days.ago)
        create(:measurement, child: child, measurement_type: "height", value: 110, measured_on: 1.day.ago)

        expect(child.latest_height).to eq(110)
      end
    end

    context "#latest_weight" do
      it "体重の最新値を返す" do
        create(:measurement, child: child, measurement_type: "weight", value: 15, measured_on: 2.days.ago)
        create(:measurement, child: child, measurement_type: "weight", value: 16, measured_on: 1.day.ago)

        expect(child.latest_weight).to eq(16)
      end
    end

    context "#latest_measured_on_h" do
      it "身長の最新測定日を返す" do
        older = create(:measurement, child: child, measurement_type: "height", measured_on: 3.days.ago)
        newer = create(:measurement, child: child, measurement_type: "height", measured_on: 1.day.ago)

        expect(child.latest_measured_on_h).to eq(newer.measured_on.to_date)
      end
    end

    context "#latest_measured_on_w" do
      it "体重の最新測定日を返す" do
        older = create(:measurement, child: child, measurement_type: "weight", measured_on: 3.days.ago)
        newer = create(:measurement, child: child, measurement_type: "weight", measured_on: 1.day.ago)

        expect(child.latest_measured_on_w).to eq(newer.measured_on.to_date)
      end
    end
  end
end
