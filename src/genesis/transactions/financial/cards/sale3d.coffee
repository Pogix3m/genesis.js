
CardBase    = require './card_base'
TransactionTypes = require '../../../helpers/transaction/types'

class Sale3d extends CardBase

  getTransactionType: ->
    TransactionTypes.SALE_3D

  constructor: (params) ->
    super params

    @set3DRequiredFields()

module.exports = Sale3d