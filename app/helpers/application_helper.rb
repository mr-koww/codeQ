module ApplicationHelper

  def bootstrap_alert_class(flash_type)
    case flash_type
      when 'success'
        "alert-success"
      when 'error'
        "alert-error"
      when 'alert'
        "alert-danger"
      when 'notice'
        "alert-info"
      else
        flash_type.to_s
    end
  end

end
