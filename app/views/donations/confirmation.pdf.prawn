prawn_document(:page_layout => :landscape) do |pdf|
  extend ActionView::Helpers::NumberHelper
  extend ActionView::Helpers::TranslationHelper

  pdf.font_families['Roboto'] = {
    :normal => { :file => File.join(Rails.root, 'assets', 'Roboto-Regular.ttf') },
  }
  pdf.font 'Roboto', :size => 12

  top = pdf.bounds.top_left[1]
  half_width = pdf.bounds.width / 2
  half_width_column_width = half_width - 5
  vspace = 20
  line_height = pdf.height_of('X')
  logo = "#{Rails.root}/assets/04_SVOBODNI_logo_tagline_BW.jpg"

  pdf.image logo, :at => [0, top], :width => half_width_column_width

  pdf.bounding_box([half_width, top], :width => half_width_column_width, :height => line_height * 5) do
    #pdf.stroke_bounds
    pdf.text(configatron.party.name)
    pdf.text(configatron.party.street)
    pdf.text("#{configatron.party.zip} #{configatron.party.city}")
    pdf.text("IČO: #{configatron.party.company_id}")
    pdf.text("č. registrace #{configatron.party.register_number}")
  end

  pdf.move_down vspace

  pdf.text('Potvrzení o přijetí daru', {
    :size => 24,
    :styles => [:bold],
    :align => :center
    })

  pdf.move_down vspace

  pdf.text("Dárce: #{@donation.name}, #{@donation.street}, #{@donation.city}, #{@donation.date_of_birth}")

  pdf.move_down vspace

  pdf.text("V souladu s § 15 odst. 1 a § 20 odst. 8 zákona č. 586/1992 Sb., zákona o daních z příjmů v platném znění, potvrzujeme, že shora uvedený dárce poskytl dne #{Date.today.year} naší politické straně finanční dar ve výši #{number_to_currency(@donation.amount, t(:'pdf.currency.format'))} (#{}). Tento dar bude použit na volební kampaň a činnost politické strany.")

  pdf.move_down vspace

  pdf.text("V Praze dne #{l(Date.today)}")
end
