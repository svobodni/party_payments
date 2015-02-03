prawn_document(:left_margin => 60, :right_margin => 60) do |pdf|
  extend ActionView::Helpers::NumberHelper
  extend ActionView::Helpers::TranslationHelper

  pdf.font_families['Roboto'] = {
    :normal => { :file => File.join(Rails.root, 'assets', 'Roboto-Regular.ttf') },
  }
  pdf.font 'Roboto', :size => 12

  width = pdf.bounds.width
  line_height = pdf.height_of('X')
  vspace = 15

  pdf.text('Darovací smlouva – finanční dar', {
    :size => 24,
    :styles => [:bold],
    :align => :center
  })

  pdf.move_down vspace

  pdf.text('I. Smluvní strany')

  pdf.table([
    ['Jméno a příjmení:', @donation.name],
    ['Bydliště:', @donation.address],
    ['Datum narození:', l(@donation.date_of_birth)]
    ], :width => 550, :column_widths => [150, 400], :cell_style => { :border_width => 0, :padding => [0,0,0,5] })

  pdf.text('(dále jen Dárce)')

  pdf.move_down vspace

  pdf.text('a')

  pdf.move_down vspace

  pdf.table([
    ['Název:', "#{configatron.party.name}"],
    ['Sídlo:', "#{configatron.party.street}, #{configatron.party.zip} #{configatron.party.city}"],
    ['IČ:', configatron.party.company_id],
    ['Zastoupená:', ''],
   ], :width => 350, :column_widths => [150, 200], :cell_style => { :border_width => 0, :padding => [0,0,0,5] })

  pdf.text('(dále jen Obdarovaný)')

  pdf.move_down vspace

  pdf.text('II. Předmět smlouvy')

  pdf.move_down vspace

  pdf.text("1. #{configatron.party.name} je politická strana, založená dle zákona č. 424/1991 Sb., o#{Prawn::Text::NBSP}sdružování v politických stranách a v politických hnutích, registrovaná u MV ČR pod#{Prawn::Text::NBSP}číslem #{configatron.party.register_number}.")
  pdf.move_down vspace
  pdf.text("2. Dárce poskytne obdarovanému na jeho činnost, finanční dar v hodnotě #{number_to_currency(@donation.amount, t(:'pdf.currency.format'))} (dále jen dar). Dar bude obdarovanému splacen na jeho účet vedený u Fio bank č.#{Prawn::Text::NBSP}ú.:#{Prawn::Text::NBSP}#{@donation.organization.account_number}/2010  a Obdarovaný dar přijímá.")
  pdf.move_down vspace
  pdf.text("3. Dárce bere na vědomí, že dar poskytnutý dle této smlouvy bude v souladu se zák. č.#{Prawn::Text::NBSP}424/1991 Sb. o sdružování v politických stranách a v politických hnutích uveden v přehledu darů uvedených ve výroční zprávě a souhlasí s použitím jím uvedených osobních údajů k tomuto účelu.")
  pdf.move_down vspace
  pdf.text("4. Tato smlouva je vyhotovena ve dvou stejnopisech, po jednom pro každou ze#{Prawn::Text::NBSP}smluvních stran.")
  pdf.move_down vspace
  pdf.text('5. Smlouva nabývá účinnosti dnem podpisu. Účastníci této smlouvy po jejím přečtení prohlašují, že souhlasí s jejím obsahem, že byla sepsána na základě pravdivých údajů, jejich svobodné vůle a nebyla ujednána v tísni ani za jinak jednostranně nevýhodných podmínek.')

  pdf.move_down vspace

  pdf.table([
    ["V Praze dne #{l(@donation.received_on)}", "V Praze dne #{l(@donation.received_on)}"],
    ['Za Stranu svobodných občanů', 'Za Dárce'],
    [{ :content => 'Podpis:', :height => line_height * 5 }, { :content => 'Podpis:', :height => line_height * 4 }]
    ], :width => width) {}
end
