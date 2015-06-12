class Mailer < ActiveRecord::Base
	

	def sample_email(email,content,filename)
		attachments[filename] = {
			mime_type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
			content: content,
		}
		mail(to: email, subject: 'Edited File')
	end
end
