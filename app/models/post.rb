class Post < ApplicationRecord
  default_scope { order created_at: :desc }
  has_one_attached :image 
  belongs_to :account
  has_many :post_hash_tags 
  has_many :hash_tags, through: :post_hash_tags 
  has_many :likes
  has_many :comments
  
  before_create :set_active
  validate :image_validation

  def image_validation
    if image.attached?
      if image.blob.byte_size < 1000000
        image.destroy
        errors[:base] << 'Too big'
      elsif !image.blob.content_type.starts_with?('image/')
        image.destroy
        errors[:base] << 'Wrong format'
      end
    else
      image.destroy
      errors[:base] << 'Attach image'
    end

  end
    scope :active, -> {where active: true }
    
    after_commit :create_hash_tags, on: :create 

    def create_hash_tags
        extract_name_hash_tags.each do |name|
            hash_tags.create(name: name)
        end
    end

    def extract_name_hash_tags 
        description.to_s.scan(/#\w+/).map{|name| name.gsub("#", "")}
    end

    private

    def set_active 
        self.active = true 
    end
end
