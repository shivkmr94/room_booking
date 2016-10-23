ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag =~ /^<label/
    if html_tag.include?("secoundsubscription[year]")
      %{<label class="message" for="#{instance.send(:tag_id)}">#{instance.error_message.first}</label>#{html_tag}}.html_safe
    else
      %{#{html_tag}<label class="message" for="#{instance.send(:tag_id)}">#{instance.error_message.first}</label>}.html_safe
    end 
  else
    %{#{html_tag}}.html_safe
  end

  # unless html_tag =~ /^<label/
  #   %{<div class="field_with_errors">#{html_tag}<br /><label class="message" for="#{instance.send(:tag_id)}">#{instance.error_message.first}</label></div>}.html_safe
  # else
  #   %{<div class="field_with_errors">#{html_tag}</div>}.html_safe
  # end
end



