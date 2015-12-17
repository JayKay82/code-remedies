require 'rails_helper'

RSpec.describe User, type: :model do

  ##################################
  ###                            ###
  ###        VALIDATIONS         ###
  ###                            ###
  ##################################

  describe "name" do
    # Test name presence and length validations
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(40) }
  end


  describe "email" do
    # Test email presence and length validations
    it { should validate_presence_of :email }
    it { should validate_length_of(:email).is_at_most(255) }

    # Test email uniqueness validation
    context "with unique email address" do
      let(:user) { build(:user) }

      it "should be valid" do
        expect(user).to be_valid
      end
    end

    context "with existing email address" do
      before do
        @user = create(:user, name: 'Mr. Special', email: 'unique@example.com')
        @user2 = build(:user, name: 'Special too', email: 'unique@example.com')
        @user3 = build(:user, name: 'So SpEcIaL',  email: 'UnIqUe@ExAmPlE.cOm')
      end

      it "should be invalid" do
        expect(@user2).not_to be_valid
      end

      it "should be invalid even with different case" do
        expect(@user3).not_to be_valid
      end
    end

    # Test email format validation
    context "with invalid email format" do
      let(:user) { build(:user) }

      it "should be invalid" do
        invalid_email_addresses = %w[ example@sample sample.com
                                      test_ing@ex_ample.net sample@example,net ]
        invalid_email_addresses.each do |invalid_email|
          user.email = invalid_email
          expect(user).not_to be_valid
        end
      end
    end

    context "with valid email format" do
      let(:user) { build(:user) }

      it "should be valid" do
        valid_email_addresses = %w[ example@sample.com ExAmPlE@SAMple.CoM
                                    mr.example@sample.net yes-sir@sample.com ]
        valid_email_addresses.each do |valid_email|
          user.email = valid_email
          expect(user).to be_valid
        end
      end
    end
  end


  describe "password" do
    # Test password length validation
    it { should validate_length_of(:password).is_at_least(8) }

    context "with invalid password format" do
      let(:user1) { build(:user, password:              'lowercase',
                                 password_confirmation: 'lowercase') }
      let(:user2) { build(:user, password:              'UPPERCASE',
                                 password_confirmation: 'UPPERCASE') }

      it "should be invalid without any uppercase characters" do
        expect(user1).not_to be_valid
      end

      it "should be invalid without any lowercase characters" do
        expect(user2).not_to be_valid
      end
    end

    context "with valid password format" do
      let(:user) { build(:user) }

      it "should be valid" do
        valid_passwords = %w[ Password PASSword passWORD PaSsWoRd ]
        valid_passwords.each do |password|
          user.password = password
          user.password_confirmation = password
          expect(user).to be_valid
        end
      end
    end
  end
end
