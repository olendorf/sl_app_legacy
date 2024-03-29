# frozen_string_literal: true

module Api
  module V1
    module Analyzable
      # Handles Transaction requests from in world.
      class TransactionsController < Api::V1::AnalyzableController
        # skip_before_action :load_requesting_object, except: [:create]
        # prepend_before_action :load_requesting_object

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
            handle_split t_split
          end
        end

        def handle_split(t_split)
          transaction = transaction_from_split t_split
          money_sent = send_request(transaction) unless Rails.env.development?
          money_sent = true if Rails.env.development?
          # rubocop:disable Style/GuardClause
          if money_sent
            @requesting_object.user.transactions << transaction
            @transaction.sub_transactions << transaction
          end
          # rubocop:enable Style/GuardClause
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

        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        def send_request(transaction)
          auth_time = Time.now.to_i
          auth_digest = Digest::SHA1.hexdigest(
            auth_time.to_s + @requesting_object.api_key
          )
          begin
            atts = {
              amount: (transaction.amount * -1),
              target_key: transaction.target_key
            }
            RestClient::Request.execute(
              url: "#{@requesting_object.url}/avatar/pay",
              method: :post,
              payload: atts.to_json,
              verify_ssl: false,
              headers: {
                content_type: :json,
                accept: :json,
                verify_ssl: false,
                params: {
                  auth_time: auth_time,
                  auth_digest: auth_digest
                }
              }
            )
            return true
          rescue StandardError
            @transaction.alert = "#{@transaction.alert}Unable to pay " \
                                 "#{transaction.target_name} #{transaction.amount}$L. "
            @transaction.save
            return false
          end
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
      end
    end
  end
end
