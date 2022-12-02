class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  <p><%= link_to 'Unlock my account', unlock_url(@resource, unlock_token: @token, host: @site_host) %></p>
end
