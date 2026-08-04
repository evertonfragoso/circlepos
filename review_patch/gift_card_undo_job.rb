# On this patch:
# - use Rails job retry handling instead of manually creating unlimited jobs.
# - adds a retry limit.
# - allows failures to be visible in job monitoring.
# - avoids swallowing unexpected exceptions.
# - uses `update!`` so database failures are not silently ignored.

class GiftCardUndoJob < ApplicationJob
  queue_as :normal_priority

  retry_on StandardError, wait: 30.seconds, attempts: 5

  def perform(site_id, transaction_id, remote_transaction_id)
    transaction = GiftCardTransaction.find(transaction_id)
    site = Site.find(site_id)

    undo_transaction(site, transaction, remote_transaction_id)
  end

  private

  def undo_transaction(site, transaction, remote_transaction_id)
    response = GiftCardService.new(
      site: site,
      card_number: transaction.card_number,
      remote_transaction_id: remote_transaction_id
    ).undo

    if response["ResponseCode"].to_i.zero?
      transaction.update!(refunded: true)
    else
      raise "Gift card undo failed: #{response.inspect}"
    end
  end
end
