# rails g model remark text:string trackable:references{polymorphic} actor:references{polymorphic}
# trackable 备注对象， actor: 评论者， text: 文本描述
# usage
# include Remarkable
module Remarkable
  def self.included(klass)
    klass.class_eval do
      has_many :remarks, as: :trackable
    end

    def create_remark text, opt = {}
      self.remarks << Remark.new(text: text, actor: opt[:actor] || Current.actor)
    end
  end
end