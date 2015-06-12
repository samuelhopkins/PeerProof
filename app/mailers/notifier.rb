class Notifier < ApplicationMailer
	default from: "sam@peerproof.com"
	layout 'mailer'

	def sample_email(paper)
		attachments[paper.filename] = {
			mime_type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
			content: paper.file_contents,
		}
		mail(to: paper.author, subject: 'Edited File')
	end
end
