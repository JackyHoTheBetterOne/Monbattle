class AbilityPurchaseCheck < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    object.errors
  end
end