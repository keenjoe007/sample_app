require 'spec_helper'

describe User do

	before do
	  @user = User.new(name:"Example User", email: "user@example.com", password:"foobar", password_confirmation:"foobar")
	end
	 #初期化して、新しいインスタンス変数を作っている。
   subject{@user}
	#モデルの属性についてテストしている。
	#respond_toメソッドは、シンボルを1つ引数として受け取って、
	#そのシンボルが表すメソッドまたは属性に対して、オブジェクトが応　　　答する場合はtrue,応答しない場合はfalseを返す。
	
	it 'should respond to name' do
	  expect(@user).to respond_to(:name)
	end

	it 'should respond to email' do
	  expect(@user).to respond_to(:email)
	end
	
	it 'should respond to password' do
	  expect(@user).to respond_to(:password_digest)
	end
  
  it 'should respond to password_confirmation' do
    expect(@user).to respond_to(:password_confirmation) 
  end
  
	it 'should be_valid' do
		expect(@user).to be_valid
	end
	#あるオブジェクトが、真偽値を返すfoo?というメソッドに応答するのであれば、
	#それに対応するbe_fooというテストメソッドが自動的に存在する。
	#この場合、「@user.valid?」の結果をテストすることができる。
	
  it 'should be respond to authenticate' do
    expect(@user).to respond_to (:authenticate)  
  end
  
	describe "when name is not present" do
		before {@user.name = ""}
		it 'should_not be_valid' do
			expect(@user).not_to be_valid
		end
	end

	describe "when name is not present" do
		before {@user.email=""}
		it 'should_not be_valid' do
			expect(@user).not_to be_valid
		end
	end
	#nameや、emailが、空の場合はvalid（有効）になっちゃいけないって意　　　味。

	describe "when name is too long" do
		before { @user.name = "a" * 51}
		it 'should_not be valid' do
			expect(@user).not_to be_valid
		end
	end
	#nameの長さに制限をかけるテスト

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@fo.COM A_US_ER@f.b.org first.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end

	describe "when email address id already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end
	end
  
  describe "when password is not present" do #新しくパスワードの無いユーザーを作ったためdescribe do~~ before do~~ end end
    before do
      @user = User.new(name:"Example User", email:"user@example.com", password:" ", password_confirmation:"")
    end
    it 'should not be valid' do
      expect(@user).not_to be_valid
    end#パスワードの存在確認テスト
  end
  
  describe "when password doesn't match confirmation" do
    before do
      @user.password_confirmation = "mismatch"  
    end
    it "should not be valid" do
      expect(@user).not_to be_valid
    end
  end
  
  describe "with a password that's too short" do
    before {@user.password = @user.password_confirmation = "a" * 5}
    it {should be_invalid}
  end
  
  describe "return value of authenticate method" do
    before{@user.save}
    let(:found_user){ User.find_by(email:@user.email)}
    #emailからuserを見つけて、found_uerに格納。
  
    describe "with valid password" do
      it {should eq found_user.authenticate(@user.password)}
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password){found_user.authenticate("invalid")}
      
      it { should_not eq user_for_invalid_password }
      specify {expect(user_for_invalid_password).to be_false}
    end
  end
end