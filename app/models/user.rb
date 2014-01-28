class User < ActiveRecord::Base
	before_save {self.email = email.downcase}
	validates :name, presence: true, length: {maximum: 50}
  #presence:trueという引数は、要素がひとつのオプションハッシュ
	
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i	
	validates :email,presence: true, 
            format: {with: VALID_EMAIL_REGEX},
            uniqueness:{ case_sensitive: false } #uniqueness:true　は、このユーザーがユニークであることを表している。
  has_secure_password #password属性とpassword_confirmation属性を追加し、パスワードが存在することを要求し、パスワードとパスワードの確認が一致することを要求し、さらにauthenticateメソッドを使用して、暗号化されたパスワードとpassword_digestを比較してユーザーを認証するという手順をこのhas_secure_passwordが実装している。
  validates :password,length: { minimum:6 }
end