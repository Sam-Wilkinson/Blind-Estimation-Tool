class RoomSearchService
  attr_accessor :search_input, :filter, :user_id

  def initialize(search_input, filter, user_id)
    self.search_input = search_input
    self.filter = filter
    self.user_id = user_id
  end

  def search
    r = if search_input.present?
          Room.where(['name LIKE ?', "%#{search_input}%"])
        else
          Room.all
        end
    included = r.joins(:users).where(users: { id: user_id }).or(r.where(admin: user_id))
    case filter
    when 'included'
      r = included
    when 'available'
      r -= included
    when 'admin'
      r = r.where(admin: user_id)
    end
    r
  end
end
