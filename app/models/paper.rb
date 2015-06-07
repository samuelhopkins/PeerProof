class Paper < ActiveRecord::Base
	before_create :set_status
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
		self.status=0
	end

	private
	def sanitize_filename(filename)
		return File.basename(filename)
	end
end
