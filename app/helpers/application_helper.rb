module ApplicationHelper
  def flash_key_mapping(key)
    {
      notice: 'success',
      alert: 'warning',
      warning: 'warning'
    }[key.to_sym]
  end
end
