@party_payments.controller 'BankPaymentIndexCtrl', ($scope, $http) ->

  $scope.bank_payments = []
  $http.get('./bank_payments.json').success((data) ->
    $scope.bank_payments = data
  )

  $scope.filterOptions =
    filterText: ''

 # $scope.gridOptions = {}
  $scope.gridOptions =
    data: 'bank_payments'
    showGroupPanel: true
    showFilter: true
 #   plugins: [new ngGridCsvExportPlugin()]
    showColumnMenu: true
    showFooter: true
    filterOptions: $scope.filterOptions
    columnDefs: [
    	{field:'paid_on', displayName:'Datum'},
        {field:'vs', displayName:'VS'},
        {field:'amount', displayName:'Castka'},
        {field:'accounting_status', displayName:'Stav', visible:false}, 
        {field:'account_name', displayName:'Nazev uctu'},
        {field:'info', displayName:'Info'},
        {field:'ss', visible:false},
        {field:'ks', visible:false},
        {field:'account_number', visible:false},
        {field:'bank_code', visible:false}
    ]


  #$scope.viewRestaurant = (id) ->
  #  $location.url "/restaurants/#{id}"
