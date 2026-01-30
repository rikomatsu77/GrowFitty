require "resend"

ActionMailer::Base.add_delivery_method :resend, Resend::DeliveryMethod
