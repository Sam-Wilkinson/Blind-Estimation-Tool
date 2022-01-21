require 'rails_helper'

RSpec.describe 'estimation_values/index', type: :view do
  it 'shows the title' do
    render
    expect(rendered).to match(t('views.estimations.values.title'))
  end

  it 'shows the create button' do
    render
    expect(rendered).to match(t('views.estimations.values.options.create'))
  end

  context 'when there are no estimation_values' do
    it 'shows the apologies call to actions' do
      render
      expect(rendered).to match(t('views.estimations.values.no_values'))
    end
  end

  it 'contains the modal for creating estimation values' do
    render
    expect(response).to render_template(partial: '_create_model')
  end

  context 'when showing the modal _create' do
    it 'shows the value field' do
      render
      expect(rendered).to match(t('active_record.attributes.estimations.values.value'))
    end

    it 'shows the placement field' do
      render
      expect(rendered).to match(t('active_record.attributes.estimations.values.placement'))
    end
  end

  context 'when there are estimation_values' do
    let(:estimation_values) { create_list(:estimation_value, 2) }

    before do
      assign(:estimation_values, estimation_values)
    end

    it 'shows estimation_value table headers' do
      render
      expect(rendered).to match(t('active_record.attributes.estimations.values.placement'))
      expect(rendered).to match(t('active_record.attributes.estimations.values.value'))
    end

    it 'shows the estimation_values' do
      render
      expect(rendered).to match(estimation_values.first.value.to_s)
      expect(rendered).to match(estimation_values.first.placement.to_s)
      expect(rendered).to match(estimation_values.second.value.to_s)
      expect(rendered).to match(estimation_values.second.placement.to_s)
    end
  end
end
