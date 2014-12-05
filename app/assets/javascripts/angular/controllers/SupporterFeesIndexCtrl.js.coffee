@party_payments.controller 'SupporterFeesIndexCtrl', ($scope, $http) ->

  $scope.supporter_fees = []
  $http.get('./supporter_fees.json').success((data) ->
    $scope.supporter_fees = data
  )

  $scope.filterOptions =
    filterText: ''

 # $scope.gridOptions = {}
  $scope.gridOptions =
    data: 'supporter_fees'
    showGroupPanel: true
    showFilter: true
 #   plugins: [new ngGridCsvExportPlugin()]
    showColumnMenu: true
    showFooter: true
    filterOptions: $scope.filterOptions
    columnDefs: [
        {field:'paid_on', displayName:'Datum'},
        {field:'amount', displayName:'Castka'},
        {field:'name', displayName:'Jméno'}, 
        {field:'address', displayName:'Adresa'},
        {field:'born_on', displayName:'Datum narozeni'},
        {field:'person_id', visible:false},
    ]


  #$scope.viewRestaurant = (id) ->
  #  $location.url "/restaurants/#{id}"
