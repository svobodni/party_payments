# -*- encoding : utf-8 -*-

class Gopay

  def self.statement(options)
    url = statement_url(options)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = http.request(Net::HTTP::Get.new(url.request_uri))
    data=res.body.force_encoding("ISO-8859-2")
    data.split("\n")[1..-1].collect{|row| row.split(';')}
  end

  def self.encrypt(message, key)
    des = OpenSSL::Cipher::Cipher.new('des-ede3')
    des.encrypt
    des.key = key
    encrypted = des.update(message) + des.final
    encrypted.unpack('H*').first
  end

  def self.statement_url(options={})
    from = options[:from].to_s
    to = options[:to].to_s
    currency = options[:currency] || 'CZK'

    message=Digest::SHA1.hexdigest(
      [
        from, to, configatron.gopay.id, currency, configatron.gopay.secret
      ].join('|')
    )
    signature = encrypt(message, configatron.gopay.secret)

    URI.parse(configatron.gopay.statement_url +
      "?statementRequest.dateFrom=" + from +
      "&statementRequest.dateTo=" + to +
      "&statementRequest.targetGoId=" + configatron.gopay.id +
      "&statementRequest.currency=" + currency +
      "&statementRequest.contentType=TYPE_CSV" +
      "&statementRequest.encryptedSignature=" + signature)
  end
end
