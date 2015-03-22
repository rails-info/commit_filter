class CommitFilter::Presenters::Frameworks::TwitterBootstrap::Version3Presenter < CommitFilter::ApplicationPresenter
  def flash_messages
    flash_messages = []
    
    flash.each do |type, message|
      flash.delete(type)
      content =  content_tag(
        :button, 
        content_tag(:span, raw('&times;'), 'aria-hidden' => 'true'), 
        class: 'close', 'data-dismiss' => 'alert', 'aria-label' => 'Close'
      )
      type = :success if ['notice'].include? type.to_s
      type = :danger   if ['alert'].include? type.to_s
      content += raw(message)
      text = content_tag(:div, content, class: "alert fade in alert-#{type}") 
      flash_messages << text if message
    end
    
    flash_messages.join('\n').html_safe
  end
  
  def form_field(filter, name, options = {})
    options[:placeholder] = t("commit_filter.filters.form.fields.#{name}.placeholder", default: 'NULL')
    options.delete :placeholder if options[:placeholder] == 'NULL'
    hint = t("commit_filter.filters.form.fields.#{name}.hint", default: 'NULL')
    hint = nil if hint == 'NULL'
    error = (filter.errors || {})[name]
    field = options.delete(:field)
    
    content_tag :div, class: 'form-group' + (error ? ' has-error' : '') do
      content = []
      content << label_tag("filter[#{name}]", t("commit_filter.filters.form.fields.#{name}.title"), class: 'col-sm-3 control-label')
      
      content << content_tag(:div, class: 'col-sm-8') do
        controls = []
         
        if field.present?
          controls << field
        else 
          controls << text_field_tag("filter[#{name}]", filter.send(name), { class: 'form-control' }.merge(options))
        end
        
        controls << content_tag(:p, hint, class: 'help-block') if hint
        controls << content_tag(:span, error, class: 'help-inline') if error
        raw controls.join(' ')
      end
      
      raw content.join(' ')
    end
  end
end