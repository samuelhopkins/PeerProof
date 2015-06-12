namespace :papercleanup do
	desc "Dissasociates papers that have been checked out for more \
	than an hour from the user. Decreases the users credits"
	task purge_papers: :environments do
		Paper.purge
	end
end