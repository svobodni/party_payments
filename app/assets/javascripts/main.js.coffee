@party_payments = angular.module('party_payments', ['ui.router', 'ngGrid'])

@party_payments.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise '/bank_payments'

  $stateProvider.state 'bank_payments',
    url: '/bank_payments'
    templateUrl: '../templates/bank_payments/index.html'

  $stateProvider.state 'supporter_fees',
    url: '/supporter_fees'
    templateUrl: '../templates/supporter_fees/index.html'

