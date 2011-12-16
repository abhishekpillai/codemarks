class User < ActiveRecord::Base

  has_many :authentications, :inverse_of => :user, :dependent => :destroy

  has_many :codemarks
  has_many :links, :through => :codemarks
  has_many :topics, :through => :codemarks#, :uniq => true
  has_many :clicks

  #validates_presence_of :authentications

  def authentication_by_provider provider
    authentications.find(:first, :conditions => ["provider = ?", provider])
  end

  def codemark_for link
    codemarks.for(link).first
  end

end
