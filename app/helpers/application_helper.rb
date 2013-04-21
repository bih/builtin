module ApplicationHelper
	def is_active?(route)
	  controller, action = route.split("#")
	  "active" if params[:controller] == controller and params[:action] == action
	end
end
