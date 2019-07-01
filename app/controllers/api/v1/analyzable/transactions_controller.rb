# frozen_string_literal: true

module Api
  module V1
    module Analyzable
      # Handles Transaction requests from in world.
      class TransactionsController < Api::V1::ApiController
        skip_before_action :load_requesting_object, except: [:create]
        prepend_before_action :load_requesting_object

        # rubocop:disable Metrics/AbcSize
        def create
          authorize ::Analyzable::Transaction
          @transaction = ::Analyzable::Transaction.new(JSON.parse(request.raw_post))
          @requesting_object.user.transactions << @transaction
          handle_splits if JSON.parse(request.raw_post)['amount'].positive?
          render json: { message: 'CREATED' }, status: :created
        end
        # rubocop:enable Metrics/AbcSize

        private

        def handle_splits
          splits = @requesting_object.user.splits
          if @requesting_object.actable&.respond_to?(:splits)
            splits += @requesting_object.actable.splits
          end
          splits.each do |t_split|
            transaction = transaction_from_split t_split
            @requesting_object.user.transactions << transaction
            @transaction.sub_transactions << transaction
          end
        end

        def transaction_from_split(t_split)
          ::Analyzable::Transaction.new(
            amount: -1 * JSON.parse(request.raw_post)['amount'] * t_split.percent,
            category: :share,
            description: "Split from transaction ##{@transaction.id}",
            rezzable_id: @requesting_object.id,
            target_name: t_split.target_name,
            target_key: t_split.target_key
          )
        end

        def api_key
          @requesting_object.api_key
        end
      end
    end
  end
end
