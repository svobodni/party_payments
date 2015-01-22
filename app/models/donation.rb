class Donation < ActiveRecord::Base

  belongs_to :organization
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable

  attr_accessor :bank_payment_id, :budget_category_id

  def address
    "#{street}, #{zip} #{city}"
  end

  def confirmation_pdf
    document = Prawn::Document.new(:page_size => 'A4') do |pdf|
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

      pdf.text("Dárce: #{name}, #{street}, #{city}, #{date_of_birth}")

      pdf.move_down vspace

      pdf.text("V souladu s § 15 odst. 1 a § 20 odst. 8 zákona č. 586/1992 Sb., zákona o daních z příjmů v platném znění, potvrzujeme, že shora uvedený dárce poskytl v roce #{Date.today.year} naší politické straně finanční dar ve výši #{number_to_currency(amount)} (#{}). Tento dar bude použit na volební kampaň a činnost politické strany.")

      pdf.move_down vspace

      pdf.text("V Praze dne #{l(Date.today)}")
    end

    document.render
  end

  def agreement_pdf
    document = Prawn::Document.new(:page_size => 'A4') do |pdf|
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
        ['Jméno a příjmení:', name],
        ['Bydliště:', address],
        ['Datum narození nebo RČ:', date_of_birth]
      ], :width => width) do
      end

      pdf.text('(dále jen Dárce)')

      pdf.move_down vspace

      pdf.text('a')

      pdf.move_down vspace

      pdf.table([
        ['Název:', configatron.party.name],
        ['Sídlo:', "#{configatron.party.street}, #{configatron.party.zip} #{configatron.party.city}"],
        ['IČ:', configatron.party.company_id],
        ['Zastoupená:', ''],
      ], :width => width) do
      end

      pdf.text('(dále jen Obdarovaný)')

      pdf.move_down vspace

      pdf.text('II. Předmět smlouvy')

      pdf.move_down vspace

      pdf.text("1. #{configatron.party.name} je politická strana, založená dle zákona č. 424/1991 Sb., o sdružování v politických stranách a v politických hnutích, registrovaná u MV ČR pod číslem #{configatron.party.register_number}.")
      pdf.text("2. Dárce poskytne obdarovanému na jeho činnost, finanční dar v hodnotě #{number_to_currency(amount)}, tj. slovy #{} korun českých (dále jen dar). Dar bude obdarovanému splacen na jeho účet vedený u Fio bank č. ú.: 2700382803/2010  a Obdarovaný dar přijímá.")
      pdf.text('3. Dárce bere na vědomí, že dar poskytnutý dle této smlouvy bude v souladu se zák.č. 424/1991 Sb. o sdružování v politických stranách a v politických hnutích uveden v přehledu darů uvedených ve výroční zprávě a souhlasí s použitím jím uvedených osobních údajů k tomuto účelu.')
      pdf.text('4. Tato smlouva je vyhotovena ve dvou stejnopisech, po jednom pro každou ze smluvních stran.')
      pdf.text('5. Smlouva nabývá účinnosti dnem podpisu. Účastníci této smlouvy po jejím přečtení prohlašují, že souhlasí s jejím obsahem, že byla sepsána na základě pravdivých údajů, jejich svobodné vůle a nebyla ujednána v tísni ani a jinak jednostranně nevýhodných podmínek.')

      pdf.move_down vspace

      pdf.table([
        ["V Praze dne #{l(Date.today)}", "V Praze dne #{l(Date.today)}"],
        ['Za Stranu svobodných občanů', 'Za Dárce'],
        [{ :content => 'Podpis:', :height => line_height * 4 }, { :content => 'Podpis:', :height => line_height * 4 }]
      ], :width => width) do
      end
    end

    document.render
  end

end
