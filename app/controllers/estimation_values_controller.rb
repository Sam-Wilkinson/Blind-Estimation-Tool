class EstimationValuesController < ApplicationController
  before_action :authenticate_user!
  def index
    @estimation_values = EstimationValue.order(placement: :ASC)
  end
end
