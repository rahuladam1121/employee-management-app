class PhoneValidator < ActiveModel::EachValidator
  PHONE_FORMAT = /\A\+?[0-9().\-\s]+\z/

  def validate_each(record, attribute, value)
    digits = value.to_s.gsub(/\D/, "")
    return if value.to_s.match?(PHONE_FORMAT) && digits.length.between?(7, 15)

    record.errors.add(attribute, "must be a valid phone number")
  end
end
