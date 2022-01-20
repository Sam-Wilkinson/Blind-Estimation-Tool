class EstimationValuesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_requested_estimation_value, only: [:destroy]
  def index
    @estimation_values = EstimationValue.order(placement: :ASC)
  end

  def create
    estimation_value = EstimationValue.new(value: params[:value], placement: params[:placement])

    if estimation_value.save
      redirect_to estimation_values_path, notice: t('views.estimations.values.flash_messages.create.success')
    else
      redirect_to estimation_values_path, alert: t('views.estimations.values.flash_messages.create.failure')
    end
  end

  def destroy
    @estimation_value.destroy
    redirect_to estimation_values_path, notice: t('views.estimations.values.flash_messages.delete.success')
  end

  private

  def estimation_values_params
    params.require(:estimation_value).permit(%i[value placement])
  end

  def set_requested_estimation_value
    @estimation_value = EstimationValue.find(params[:id])
  end
end
