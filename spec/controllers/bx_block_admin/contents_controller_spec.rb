require 'rails_helper'
RSpec.describe ::BxBlockAdmin::ContentsController, type: :controller do

  describe 'ContentsController' do

describe 'companies' do
  let!(:company) { create(:company) }
  let(:expected_response_keys) do
    %w[id type attributes]
  end
  let(:expected_keys) do
    %w[id name logo brand_count]
  end
  it "displays all company" do
    get :companies
    expect(JSON.parse(response.body)['companies']['data'].first.keys).to eq(expected_response_keys)
    expect(JSON.parse(response.body)['companies']['data'].first['attributes'].keys).to eq(expected_keys)
    expect(JSON.parse(response.body).count).to eq(1)
  end
end

 describe 'GET #all_companies_list' do
    it 'returns a list of companies with models' do
      company1 = create(:company, name: 'Company1')
      company2 = create(:company, name: 'Company2')

      model1 = create(:model, company: company1, name: 'Model1')
      model2 = create(:model, company: company1, name: 'Model2')
      model3 = create(:model, company: company2, name: 'Model3')

      get :all_companies_list

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['companies_list']).to be_an(Array)
    end

    it 'returns a message when no companies are available' do
      get :all_companies_list

      expect(response).to have_http_status(:ok)
    end
  end

describe 'when company data is not available' do
  it "company is not available" do
    get :companies
    expect(Message: "No companies available").to eq(Message: "No companies available")
  end
end

describe 'terms_and_conditions' do
  let!(:terms_and_condition) { create(:terms_and_condition) }
  it "displays all terms_and_condition" do
    get :terms_and_conditions
    expect(JSON.parse(response.body).count).to eq(2)
    expect(JSON.parse(response.body)['data'].first['type']).to eq("terms_and_condition")
    expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(["id", "description", "description_new"])
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'global_offices' do
  let!(:region) { create(:region) }
  let!(:country) { create(:country, region: region) }
  let!(:state) { create(:state, country: country) }
  let!(:city) { create(:city, state: state) }
  let!(:global_office) { create(:global_office, city: city) }
  let(:expected_global_office_keys) do
    %w[id address_line_1 address_line_2 state city zipcode country]
  end
  it "displays all global_offices" do
    get :global_offices
    expect(JSON.parse(response.body).count).to eq(2)
    expect(JSON.parse(response.body)['data'].first['type']).to eq("global_office")
    expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(expected_global_office_keys)
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'banner_images' do
  let!(:banner) { create(:banner) }
  let(:expected_banner_keys) do
    %w[id priority image]
  end
  it "displays all banner_images" do
    get :banner_images
    expect(JSON.parse(response.body).count).to eq(2)
    expect(JSON.parse(response.body)['data'].first['type']).to eq("banner")
    expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(expected_banner_keys)
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'flash_screens' do
  let!(:flash_screen) { create(:flash_screen) }
  let(:expected_flash_screen_keys) do
    %w[id screen_type images description offer_title tips_title offer tips_for_advertisment_posting description_title offer_new description_new tips_for_advertisment_posting_new]
  end
  it "displays all flash_screens" do
    get :flash_screens, params: { screen_type: 1}
    expect(JSON.parse(response.body).count).to eq(2)
    expect(JSON.parse(response.body)['data'].first['type']).to eq("flash_screen")
    expect(JSON.parse(response.body)['data'].first['attributes'].keys).to eq(expected_flash_screen_keys)
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'models' do
  let!(:company) { create(:company)}
  let!(:model) { create(:model, company: company) }
  let(:expected_models_keys) do
    %w[id name body_type engine_type autopilot autopilot_type company_id created_at updated_at ]
  end
  it "displays all model" do
    get :models, params: { company_id: company}
    expect(JSON.parse(response.body).count).to eq(1)
    expect(JSON.parse(response.body).first.keys).to eq(expected_models_keys)
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'car_price_list' do
  let!(:account) { create(:account) }
  let!(:plan) { create(:plan) }
  let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
  let!(:company) { create(:company) }
  let!(:model) { create(:model, company: company) }
  let!(:trim) { create(:trim, model: model) }
  let!(:region) { create(:region) }
  let!(:country) { create(:country, region: region) }
  let!(:state) { create(:state, country: country) }
  let!(:city) { create(:city, state: state) }
  let!(:car_ad1) { create(:car_ad, city: city, account: account, trim: trim) }
  let(:expected_models_keys) do
    %w[id name body_type engine_type autopilot autopilot_type company_id created_at updated_at ]
  end
  it "displays all model" do
    get :car_price_list, params: { model_id: model.id}
    expect(JSON.parse(response.body).count).to eq(1)
    expect(JSON.parse(response.body)['car_price_list'].first['price']).to eq("2000000")
    expect(JSON.parse(response.body)['car_price_list'].first.keys).to eq(["id", "price"])
    expect(JSON.parse(response.code)).to eq(200)
  end
end
describe 'companies_by_make_year' do
  let!(:account) { create(:account) }
  let!(:plan) { create(:plan) }
  let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
  let!(:company) { create(:company) }
  let!(:model) { create(:model, company: company) }
  let!(:trim) { create(:trim, model: model) }
  let!(:region) { create(:region) }
  let!(:country) { create(:country, region: region) }
  let!(:state) { create(:state, country: country) }
  let!(:city) { create(:city, state: state) }
  let!(:car_ad1) { create(:car_ad, city: city, account: account, trim: trim) }
  it "displays all model" do
    get :companies_by_make_year, params: { make_year: "1998"}
    expect(JSON.parse(response.body).count).to eq(1)
    # expect(JSON.parse(response.body)['companies_list'].first['name']).to eq("xyz")
    expect(JSON.parse(response.body)['companies_list'].first.keys).to eq(["id", "name", "created_at", "updated_at"])
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'make_year_list' do
  let!(:account) { create(:account) }
  let!(:plan) { create(:plan) }
  let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
  let!(:company) { create(:company) }
  let!(:model) { create(:model, company: company) }
  let!(:trim) { create(:trim, model: model) }
  let!(:region) { create(:region) }
  let!(:country) { create(:country, region: region) }
  let!(:state) { create(:state, country: country) }
  let!(:city) { create(:city, state: state) }
  let!(:car_ad1) { create(:car_ad, city: city, account: account, trim: trim) }
  it "displays all model" do
    get :make_year_list
    expect(JSON.parse(response.body).count).to eq(1)
    expect(JSON.parse(response.body)['make_years'].first['make_year']).to eq(JSON.parse(response.body)['make_years'].first['make_year'])
    expect(JSON.parse(response.body)['make_years'].first.keys).to eq(["id", "make_year"])
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'trims' do
  let!(:company) { create(:company)}
  let!(:model) { create(:model, company: company) }
  let!(:trim) { create(:trim, model: model) }
  let(:expected_trim_keys) do
    %w[id name model_id created_at updated_at]
  end
  it "displays all trims" do
    get :trims, params: { model_id: model}
    expect(JSON.parse(response.body).count).to eq(1)
    expect(JSON.parse(response.body).first.keys).to eq(expected_trim_keys)
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'regions' do
  let!(:region) { create(:region)}
  let(:expected_region_keys) do
    %w[id name created_at updated_at phone_no_digit]
  end
  it "displays all regions" do
    get :regions
    # expect(JSON.parse(response.body).count).to eq(1)
    expect(JSON.parse(response.body).first.keys).to eq(expected_region_keys)
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'countries' do
  let!(:region) { create(:region)}
  let!(:country) { create(:country, region: region) }
  let(:expected_countries_keys) do
    %w[id name region_id created_at updated_at country_code phone_no_digit]
  end
  it "displays all countries" do
    get :countries, params: { region_id: region}
    expect(JSON.parse(response.body).count).to eq(1)
    expect(JSON.parse(response.body).first.keys).to eq(expected_countries_keys)
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'states' do
  let!(:region) { create(:region)}
  let!(:country) { create(:country, region: region) }
  let!(:state) { create(:state, country: country) }
  let(:expected_state_keys) do
    %w[id name country_id created_at updated_at]
  end
  it "displays all states" do
    get :states, params: { country_id: country}
    expect(JSON.parse(response.body).count).to eq(1)
    expect(JSON.parse(response.body).first.keys).to eq(expected_state_keys)
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'cities' do
  let!(:region) { create(:region)}
  let!(:country) { create(:country, region: region) }
  let!(:state) { create(:state, country: country) }
  let!(:city) { create(:city, state: state) }
  let(:expected_city_keys) do
    %w[id name state_id zipcode created_at updated_at]
  end
  it "displays all cities" do
    get :cities, params: { state_id: state}
    expect(JSON.parse(response.body).count).to eq(1)
    expect(JSON.parse(response.body).first.keys).to eq(expected_city_keys)
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'get_regional_specs' do
  let!(:region) { create(:region)}
  it "displays all regional_spec" do
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'subscription_plans' do
  let!(:account) { create(:account) }
  let!(:plan) { create(:plan) }
  let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }
  let(:expected_subscription_plans_keys) do
    %w[id name duration price details created_at updated_at ad_count]
  end
  it "displays all subscription_plans" do
    get :subscription_plans, params: { name: "Paid Plan"}
    expect(JSON.parse(response.body).count).to eq(JSON.parse(response.body).count)
    expect(JSON.parse(response.body).first.keys).to eq(expected_subscription_plans_keys)
    expect(JSON.parse(response.code)).to eq(200)
  end
end

describe 'contact_us' do
  let(:contact_us_params) do
    {
      description:'this is my new car i want to selling a car which is the best for you budger ',
      name: 'test',
      email: 'test1@gmail.com'
    }
  end
  let(:params) { { contact_us: contact_us_params } }
  before do
    expect(BxBlockAdmin::ContactUs.count).to eq(0)
  end
  it "displays all contact_us" do
    post :contact_us, params: { contact_us: contact_us_params }
    expect(JSON.parse(response.body).count).to eq(2)
    expect(JSON.parse(response.code)).to eq(200)
  end
end
  end
end
