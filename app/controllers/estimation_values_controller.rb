class EstimationValuesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin_status
  before_action :set_requested_estimation_value, only: %i[update destroy]

  def index
    @estimation_values = EstimationValue.order(placement: :ASC)
  end

  def create
    estimation_value = EstimationValue.new(estimation_values_params)

    if estimation_value.save
      redirect_to estimation_values_path, notice: t('views.estimations.values.flash_messages.create.success')
    else
      redirect_to estimation_values_path, alert: t('views.estimations.values.flash_messages.create.failure')
    end
  end

  def update
    if @estimation_value.update(estimation_values_params)
      redirect_to estimation_values_path, notice: t('views.estimations.values.flash_messages.update.success')
    else
      redirect_to estimation_values_path, alert: t('views.estimations.values.flash_messages.update.failure')
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

  def authenticate_admin_status
    redirect_to root_path, warning: t('views.estimations.values.flash_messages.access.denied') unless current_user.isAdmin
  end
end
