if defined?(Resend::DeliveryMethod)
  ActionMailer::Base.add_delivery_method :resend, Resend::DeliveryMethod
end
