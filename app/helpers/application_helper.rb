module ApplicationHelper
  def bold_link_to(name, url, user=nil)
    # if user.present? && user.role == "Account Manager"
    if user.present? && user == current_user
      link_to "<strong>#{name}</strong>".html_safe, url
    else
      link_to "#{name}".html_safe, url
    end
  end
end


# def bold_link_to(name, url, user=nil)
#   if user.present? && user == current_user
#     "Name: #{name}  " + " Link: #{url} " + "User: #{user.id}"
#   else
#     "Name: #{name}  " + " Link: #{url} "
#   end
# end