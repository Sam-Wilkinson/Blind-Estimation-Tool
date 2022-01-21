module ApplicationHelper
  def flash_key_mapping(key)
    {
      notice: 'success',
      warning: 'warning',
      info: 'info',
      alert: 'danger'
    }[key.to_sym]
  end
end
