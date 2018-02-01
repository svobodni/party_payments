class DonationAgreementPdf < Prawn::Document
  def initialize(donation)
    super()

    extend ActionView::Helpers::NumberHelper
    extend ActionView::Helpers::TagHelper
    extend ActionView::Helpers::TranslationHelper

    font_families['Montserrat'] = {
      :normal => { :file => File.join(Rails.root, 'assets', 'Montserrat-Regular.ttf') },
    }
    font 'Montserrat', :size => 10

    width = bounds.width
    line_height = height_of('X')
    vspace = 15

    pad = 20
    width = bounds.width-2*pad
    bounding_box([pad, bounds.height - pad], :width => bounds.width - (pad * 2), :height => bounds.height - (pad * 2)) do

    image  File.join(Rails.root, 'assets', 'Svobodni_logo_RGB.png'), width: 150

    bounding_box([bounds.width-160,bounds.height+30], width: width) do
      table([
        ["Variabilní symbol:", donation.vs || "9#{donation.id}"],
        ["Zpráva pro příjemce:", "DAR"],
        ["Částka:", "#{number_to_currency(donation.amount)}"],
        ["Číslo účtu:", "7505075050/2010"]
      ], cell_style: { size: 10, padding: [2,2,2,2], border_width: 0 }) do |t|
        t.cells.border_width = 0
        t.cells.border_color = "009681"
        t.before_rendering_page do |page|
          page.row(0).border_top_width =3
          page.row(-1).border_bottom_width =3
          page.column(0).border_left_width =3
          page.column(-1).border_right_width = 3
        end
      end
    end if donation.monetary?
    move_down vspace

    text("Darovací smlouva – #{donation.monetary? ? 'finanční':'nepeněžní'} dar", {
      :size => 24,
      :styles => [:bold],
      :align => :center
    })

    move_down vspace

    text('I. Smluvní strany', align: :center)
    move_down vspace
    if donation.donor_type=="juristic"
      table([
        ['Právnická osoba:', donation.name],
        ['Sídlo:', donation.address],
        ['IČ:', donation.ic]
        ], :width => 550, :column_widths => [150, 400], :cell_style => { :border_width => 0, :padding => [0,0,0,5] })
    else
      table([
        ['Jméno a příjmení:', donation.name],
        ['Bydliště:', donation.address],
        ['Datum narození:', l(Date.parse(donation.date_of_birth.to_s))]
        ], :width => 550, :column_widths => [150, 400], :cell_style => { :border_width => 0, :padding => [0,0,0,5] })
    end

    text('(dále jen Dárce)')

    move_down vspace

    text('a', align: :center)

    move_down vspace

    table([
      ['Název:', "#{configatron.party.name}"],
      ['Sídlo:', "#{configatron.party.street}, #{configatron.party.zip} #{configatron.party.city}"],
      ['IČ:', configatron.party.company_id],
      ['Zastoupená:', "#{donation.monetary? ? '' : 'Ing. Petrem Machem, PhD.'}"],
     ], :width => 350, :column_widths => [150, 200], :cell_style => { :border_width => 0, :padding => [0,0,0,5] })

    text('(dále jen Obdarovaný)')

    move_down vspace

    text('II. Předmět smlouvy', align: :center)

    par_2 = donation.monetary? ?
      "Dárce poskytne obdarovanému na jeho činnost finanční dar v hodnotě #{number_to_currency(donation.amount)} (dále jen dar). Dar bude obdarovanému splacen na jeho účet vedený u Fio banky č.#{Prawn::Text::NBSP}ú.:#{Prawn::Text::NBSP}7505075050/2010 a Obdarovaný dar přijímá." :
      "Dárce poskytne obdarovanému na jeho činnost nepeněžní dar - #{donation.description}. Hodnota daru je stanovena na částku #{number_to_currency(donation.amount)} a vychází z obvyklých cenových podmínek dárce. Obdarovaný dar přijímá."
    move_down vspace
    table([
      ["1.","#{configatron.party.name} je politická strana, založená dle zákona č. 424/1991 Sb., o#{Prawn::Text::NBSP}sdružování v politických stranách a v politických hnutích, registrovaná u MV ČR pod#{Prawn::Text::NBSP}číslem #{configatron.party.register_number}."],
      ["2.",par_2],
      ["3.","Dárce bere na vědomí, že dar poskytnutý dle této smlouvy bude v souladu se zák. č.#{Prawn::Text::NBSP}424/1991 Sb. o sdružování v politických stranách a v politických hnutích uveden v přehledu darů uvedených ve výroční zprávě a souhlasí s použitím jím uvedených osobních údajů k tomuto účelu."],
      ["4.","Tato smlouva je vyhotovena ve dvou stejnopisech, po jednom pro každou ze#{Prawn::Text::NBSP}smluvních stran."],
      ['5.','Smlouva nabývá účinnosti dnem podpisu. Účastníci této smlouvy po jejím přečtení prohlašují, že souhlasí s jejím obsahem, že byla sepsána na základě pravdivých údajů, jejich svobodné vůle a nebyla ujednána v tísni ani za jinak jednostranně nevýhodných podmínek.']
      ],:cell_style => { :border_width => 0})

    move_down vspace*2

    # sig_1 = donation.monetary? ?
    #   { :content => 'Podpis:', :height => line_height * 5 } :
    #   { :image=> File.join(Rails.root, 'assets', 'petr_mach_w.png'), :height => line_height * 5 }

    sig_1 = { :content => 'Podpis:', :height => line_height * 5 }

    table([
      ["V Praze dne #{donation.monetary? ? '' : l(donation.created_at.to_date)}", "V .................... dne ...................."],
      ["Za Svobodné #{donation.monetary? ? '' : 'Ing. Petr Mach, PhD.'}", 'Za Dárce'],
      [sig_1, { :content => 'Podpis:', :height => line_height * 4 }]
      ], :width => width) {}
   end

   text(donation.try(:access_token), align: :center, size: 8) unless donation.monetary?
 end
end
