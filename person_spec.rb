require 'rails_helper'

RSpec.describe Person do
  let(:delivery) { double }
  let(:admins) { double }

  describe "#send_validation_email" do
    before { allow(Person).to receive(:admins) { admins }}

    it "sends a validation email to the person" do
      expect(delivery).to receive(:deliver)
      expect(Emails).to receive(:validate_email).with(subject).and_return(delivery)

      subject.send_validation_email
    end

    it "sends a validation email sent email to the admins" do
      expect(delivery).to receive(:deliver)
      expect(Emails).to receive(:admin_new_user).with(admins, subject).and_return(delivery)

      subject.send_validation_email
    end
  end

  describe "#validate_email" do
    it "updates a person to validated" do
      subject.validate_email
      expect(subject.validated).to be_true
    end

    it "sends a person validated email to admins" do
      expect(delivery).to receive(:deliver)
      expect(Emails).to receive(:admin_user_validated).with(admins, subject).and_return(delivery)
    end
  end

  describe "#send_welcome_email" do
    it "sends a welcome email to the person" do
      expect(delivery).to receive(:deliver!)
      expect(Emails).to receive(:welcome).with(subject).and_return(delivery)
    end
  end

  describe "#generate_slug" do
    let!(:now) { Time.parse('Feb 16 2016') }

    before do
      allow(Time).to receive(:now) { now }
      allow(subject).to receive(:rand) { 5 }
    end

    it "generates an email validation slug for the person" do
      subject.generate_slug
      expect(subject.slug).to eq("ABC123#{now.to_i.to_s}12398275")
    end
  end

  describe "#generate_team_and_handle" do
    context "when person count is odd" do
      before { allow(Person).to receive(:count) { 4 }}

      it "sets the person's team" do
        subject.generate_team_and_handle
        expect(subject.team).to eq('UnicornRainbows')
      end

      it "sets the person's handle" do
        subject.generate_team_and_handle
        expect(subject.handle).to eq('UnicornRainbows5')
      end
    end

    context "when person count is even" do
      before { allow(Person).to receive(:count) { 5 }}

      it "sets the person's team" do
        subject.generate_team_and_handle
        expect(subject.team).to eq('LaserScorpions')
      end

      it "sets the person's handle" do
        subject.generate_team_and_handle
        expect(subject.handle).to eq('LaserScorpions6')
      end
    end
  end
end