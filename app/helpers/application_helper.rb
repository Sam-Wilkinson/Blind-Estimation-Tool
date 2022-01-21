module ApplicationHelper
  def flash_key_mapping(key)
    {
      notice: 'success',
      warning: 'warning',
      alert: 'danger'
    }[key.to_sym]
  end
end
