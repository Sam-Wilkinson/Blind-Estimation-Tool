class EstimationValuesController < ApplicationController
  before_action :authenticate_user!
  def index
    @estimation_values = EstimationValue.order(placement: :ASC)
  end

  def create
    estimation_value = EstimationValue.new(value: params[:value], placement: params[:placement])

    flash[:alert] = if estimation_value.save
                      t('views.estimations.values.flash_messages.success')
                    else
                      t('views.estimations.values.flash_messages.failure')
                    end
    redirect_to estimation_values_path
  end
end
