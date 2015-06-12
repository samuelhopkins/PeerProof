# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview
	def sample_mail_preview
		Notifier.sample_email(Paper.first)
	end
end
