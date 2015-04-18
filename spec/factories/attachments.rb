FactoryGirl.define do
  factory :attachment do
    file { File.new( "#{Rails.root}/public/404.html" ) }
  end
end