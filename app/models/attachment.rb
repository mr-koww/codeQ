class Attachment < ActiveRecord::Base
  validates :file, presence: true

  belongs_to :attachable, polymorphic: true

  mount_uploader :file, FileUploader
end