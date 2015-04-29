module ApplicationHelper

  def bootstrap_alert_class(flash_type)
      alert_classes = { success: 'alert-success', error: 'alert-error', alert: 'alert-danger', notice: 'alert-info' }
      alert_classes[flash_type.to_sym] || flash_type.to_s
    end

end
