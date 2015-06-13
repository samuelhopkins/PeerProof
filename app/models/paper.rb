class Paper < ActiveRecord::Base
	before_create :set_status
	belongs_to :user
	validates_acceptance_of :content_type, :accept =>'application/vnd.openxmlformats-officedocument.wordprocessingml.document', :message => 'must be .docx'
	validates_uniqueness_of :filename
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


	def set_status
		self.status=:created
		self.user_id=nil
	end

	def self.purge
		papers=Paper.all
		papers.each do |paper|
			if Time.now > (paper.updated_at + 1.hours) and paper.status=='downloaded'
				user=paper.user
				to_destroy=Paper.find_by(author: user.email)
				paper.user=nil
				paper.status='created'
				paper.save
				user.paper=nil
				user.credits=0
				user.save
				if to_destroy.present?
					to_destroy.delete
				end
			end
		end
	end

	

	private
	def sanitize_filename(filename)
		return File.basename(filename)
	end
end
