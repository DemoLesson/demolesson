require 'test_helper'

class PricingModelTest < ActiveSupport::TestCase
  test "should fail to save without region" do
    pm = default_model
    pm.region = nil
    assert !pm.save, "Able to save pricing model without region."
  end

  test "should fail to save without country" do
    pm = default_model
    pm.country = nil
    assert !pm.save, "Able to save pricing model without country."
  end

  test "should fail to save without cycle length" do
    pm = default_model
    pm.cycle_length = nil
    assert !pm.save, "Able to save pricing model with empty cycle length."
  end

  test "should fail to save without valid cycle length" do
    pm = default_model
    pm.cycle_length = "Bi-Annually"
    assert !pm.save, "Able to save pricing model with invalid cycle length."
  end
  
  test "should fail to save without price per cycle" do
    pm = default_model
    pm.price_per_cycle = nil
    assert !pm.save, "Able to save pricing model with empty price per cycle."
  end

  private

  def default_model
    return PricingModel.new(:country => "United States",
                            :region  => "Texas",
                            :cycle_length => "Annually",
                            :price_per_cycle => 1024.52)
  end
end
