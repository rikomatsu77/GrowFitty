# config/initializers/i18n_monkey_patch.rb
module I18nMonkeyPatch
  def translate(key = nil, *, throw: false, raise: false, locale: nil, **options)
    Rails.logger.warn "🚨 I18n key: #{key}"
    super
  end
end

I18n.singleton_class.prepend(I18nMonkeyPatch)
