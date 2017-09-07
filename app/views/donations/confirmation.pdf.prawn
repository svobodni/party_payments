prawn_document(:left_margin => 60, :right_margin => 120, :bottom_margin => 25) do |pdf|
  extend ActionView::Helpers::NumberHelper
  extend ActionView::Helpers::TranslationHelper

  pdf.font_families['Montserrat'] = {
    :normal => { :file => File.join(Rails.root, 'assets', 'Montserrat-Regular.ttf') },
    :bold => { :file => File.join(Rails.root, 'assets', 'Montserrat-Bold.ttf') },
  }
  pdf.font 'Montserrat', :size => 10

  top = pdf.bounds.top_left[1]
  half_width = pdf.bounds.width / 2
  half_width_column_width = half_width - 5
  vspace = 20
  line_height = pdf.height_of('X')

  pdf.image File.join(Rails.root, 'assets', 'Svobodni_logo_RGB.png'), :at => [-20, top], :width => 220

  pdf.bounding_box([300, top], :width => half_width_column_width, :height => line_height * 10) do
    #pdf.stroke_bounds
    pdf.text("V Praze dne #{l(@donation.received_on)}", {:style => :bold, :color => "009681"})
    pdf.move_down vspace*3
    pdf.text(@donation.name, :styles => [:bold])
    pdf.text(@donation.street)
    pdf.text("#{@donation.zip} #{@donation.city}")
  end

  pdf.move_down vspace

  pdf.text('Potvrzení o přijetí daru', { :size => 12, :color => "009681" })

  pdf.move_down vspace

  pdf.text("Číslo: #{@donation.number}")

  pdf.move_down vspace

  if @donation.donor_type=="juristic"
    pdf.text("Dárce: #{@donation.name}, #{@donation.street}, #{@donation.city}, IČ #{@donation.ic}")
  else
    pdf.text("Dárce: #{@donation.name}, #{@donation.street}, #{@donation.city}, nar. #{l Date.parse(@donation.date_of_birth.to_s)}")
  end

  pdf.move_down vspace

  pdf.text("V souladu s § 15 odst. 1 a § 20 odst. 8 zákona č. 586/1992 Sb., zákona o daních z#{Prawn::Text::NBSP}příjmů v#{Prawn::Text::NBSP}platném znění, potvrzujeme, že shora uvedený dárce poskytl dne #{l @donation.received_on} naší politické straně finanční dar ve výši #{number_to_currency(@donation.amount, t(:'pdf.currency.format'))}. Tento dar bude použit na volební kampaň a činnost politické strany.")

  pdf.move_down vspace

  pdf.move_down vspace*3

  pdf.stroke do
    pdf.image File.join(Rails.root, 'assets', 'petr_mach_w.png'), :height => line_height * 3
    pdf.horizontal_line(0, 135)
    pdf.move_down 5
    pdf.text("Za Stranu svobodných občanů")
    pdf.text("Ing. Petr Mach, Ph.D.")
    pdf.text("předseda")
  end

  #pdf.text("Ing. Jiří Kubíček")
  #pdf.text("předseda krajského sdružení Praha", :color => "00654E")


  pdf.repeat :all do
    pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 35], :width  => pdf.bounds.width+35 do
      pdf.table([
        [configatron.party.name, configatron.party.phone, "Bankovní konto: #{configatron.party.bank_account_number}"],
        [configatron.party.street, configatron.party.email, "Č. registrace: #{configatron.party.register_number}"],
        ["#{configatron.party.zip} #{configatron.party.city}", configatron.party.web, "IČ: #{configatron.party.company_id}"]
      ], :column_widths => [150, 150, 150], :cell_style => { :size => 7, :padding => [0,0,0,5], :text_color => "009681", :border_color => "009681" }) do
        columns(0..2).borders = [:left]
      end

    end
  end
end
