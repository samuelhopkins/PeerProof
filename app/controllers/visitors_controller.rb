class VisitorsController < ApplicationController
	def index
		@user=current_user
		if current_user.present?
			if current_user.paper.present?
				@paper=current_user.paper
			end
		end
	end

end
