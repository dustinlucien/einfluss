# == Schema Information
# Schema version: 20110505224141
#
# Table name: users
#
#  id            :integer         not null, primary key
#  firstname     :string(255)
#  lastname      :string(255)
#  email         :string(255)
#  twitter       :string(255)
#  github        :string(255)
#  stackoverflow :string(255)
#  company       :string(255)
#  location      :string(255)
#  joined        :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class User < ActiveRecord::Base
	attr_accessible :firstname, :lastname, :email, :github, :twitter, :stackoverflow, :company, :location
end
