class Paper < ActiveRecord::Base
	before_create :set_status
	before_save :call_inspect
	belongs_to :user
	validates_acceptance_of :content_type, :accept =>'application/vnd.openxmlformats-officedocument.wordprocessingml.document', :message => 'must be .docx'
	
	enum status: [ :created, :downloaded, :edited, :edit ]

	def initialize(params = {})
		file=params.delete(:file)
		super
		if file
			self.filename = sanitize_filename(file.original_filename)
			self.content_type = file.content_type
			self.file_contents = file.read
		end
	end


	def change_status_to_downloaded
		self.status='downloaded'
		self.save
	end

	def set_status
		self.status=:created
		self.user_id=nil
	end

	def call_inspect
		puts "The paper is being saved"
		puts self.inspect
	end

	private
	def sanitize_filename(filename)
		return File.basename(filename)
	end
end
