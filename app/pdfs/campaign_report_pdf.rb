class CampaignReportPdf < Prawn::Document
  def initialize()
    super(page_layout: :landscape)

    extend ActionView::Helpers::NumberHelper
    extend ActionView::Helpers::TagHelper
    extend ActionView::Helpers::TranslationHelper

    font_families['Montserrat'] = {
      :normal => { :file => File.join(Rails.root, 'assets', 'Roboto-Regular.ttf') },
      :bold => { :file => File.join(Rails.root, 'assets', 'Roboto-Bold.ttf') },
    }
    font 'Montserrat', :size => 12

    width = bounds.width
    line_height = height_of('X')
    vspace = 15

    pad = 20
    width = bounds.width-2*pad
    bounding_box([pad, bounds.height - pad], :width => bounds.width - (pad * 2), :height => bounds.height - (pad * 2)) do

      image  File.join(Rails.root, 'assets', 'Svobodni_logo_RGB.png'), width: 150

      move_down vspace

      text('Zpráva o financování volební kampaně', align: :center, style: :bold, size: 18)
      move_down vspace/2
      text('Kandidující subjekt Strana svobodných občanů', style: :bold)
      move_down vspace/2
      text('Volby do Poslanecké sněmovny Parlamentu České republiky', style: :bold)
      move_down vspace/2
      text('konané ve dnech 20. a 21. října 2017', style: :bold)
      move_down vspace
      text('Část I.', style: :bold)
      move_down vspace/4
      text('Peněžité dary poskytnuté kandidujícímu subjektu', style: :bold)
      text('počet stran ..... v části I.')
      @donations=Donation.where("received_on > ?","2017-05-01")
      text("Celkem #{number_to_currency @donations.sum(:amount)} v části I.")
      move_down vspace
      @data=@donations.order(created_at: :desc).collect{|d|
        if d.juristic?
          [[d.name, d.address].join(', '), d.ic, number_to_currency(d.amount)]
        else
          [[d.name, d.city].join(', '), l(d.date_of_birth), number_to_currency(d.amount)]
        end
      }

      table(
        [['Dárce', 'Datum narození / identifikační číslo dárce','Výše peněžitého daru']]+@data,
        :width => 700, :column_widths => [400,150, 150], :cell_style => { :border_width => 1, :padding => [0,5,1,5] }) do
          style(column(1), align: :center)
          style(column(2), align: :right)
        end

        # start_new_page(layout: :landscape)
        start_new_page()
        text('Část II.', style: :bold)
        move_down vspace/4
        text('Jiná bezúplatná plnění poskytnutá kandidujícímu subjektu', style: :bold)
        text('počet stran ..... v části II.')
        @donations=NonMonetaryDonation.agreement_received
        text("Celkem #{number_to_currency @donations.sum(:amount)} v části II.")
        move_down vspace
        @data=@donations.order(created_at: :desc).collect{|d|
          if d.juristic?
            [[d.name, d.address].join(', '), d.ic, number_to_currency(d.amount), d.description]
          else
            [[d.name, d.city].join(', '), l(d.date_of_birth), number_to_currency(d.amount), d.description]
          end
        }

        table(
          [['Dárce', 'Datum narození / identifikační číslo dárce','Obvyklá cena','Bezúplatné plnění']]+@data,
          :width => 700, :column_widths => [250,100, 100,250], :cell_style => { :border_width => 1, :padding => [0,5,1,5] }) do
            style(column(1), align: :center)
            style(column(2), align: :right)
          end
        start_new_page()
          text('Část III.', style: :bold)
          move_down vspace/4
          text('Výdaje hrazené kandidáty', style: :bold)
          text('počet stran ..... v části III.')
          text("Celkem 0 Kč v části III.")
          move_down vspace
          @data=[]

          table(
            [['Kandidát', 'Výše výdajů']]+@data,
            :width => 400, :column_widths => [300,100], :cell_style => { :border_width => 1, :padding => [0,5,1,5] }) do
              style(column(1), align: :right)
            end

      start_new_page()
        text('Část IV.', style: :bold)
        move_down vspace/4
        text('Výdaje na volební kampaň', style: :bold)
        text('počet stran ..... v části IV.')
        @payments=BankAccount.find(6).payments.where("amount < 0")
        text("Celkem #{number_to_currency @payments.sum(:amount)*-1} v části IV.")
        move_down vspace
        @data=@payments.collect{|p| [number_to_currency(p.positive_amount), p.info]}

        table(
          [['Částka Kč', 'Účel, na který byla použita']]+@data,
          :width => 700, :column_widths => [200,500], :cell_style => { :border_width => 1, :padding => [0,5,1,5] }) do
            style(column(0), align: :right)
          end
        move_down vspace/4
        text('Žádná plnění nebyla poskytnuta za cenu nižší, než obvyklou.')
      start_new_page()
        text('Část V.', style: :bold)
        move_down vspace/4
        text('Peněžité dluhy, k jejichž splnění se kandidující subjekt v souvislosti s financováním volební kampaně zavázal', style: :bold)
        text('počet stran ..... v části V.')
        text("Celkem 0 Kč v části V.")
        move_down vspace
        @data=[]

        text('Datum .........................', style: :bold)
        move_down vspace*4
        text('Podpis .........................', style: :bold)

   end


  number_pages("Strana <page>/<total>", {
                                      :at => [bounds.right - 60, 0],
                                      :align => :right,
                                      :size => 10})

 end
end
