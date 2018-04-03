require 'rails_helper'
require 'reading_requests/initiate'

RSpec.describe "Reading Requests End to End Integration Test" do
	# Note -- we can use a lazy let here because we will
	# end up creating out kitty with our action on ln 28
	let(:kitty) { FactoryBot.create(:cat) }
	let(:request_data) do
		{
			genre: "romance",
			num_books: 5,
			urgency: "asap"
		}
	end

	# Use let! to define and evaluate these immediately
	# Alternatively, you could do this in a before block
	# before do
	#   wrangler_1
	#   wrangler_2
	# end
	let!(:wrangler_1) { FactoryBot.create(:cat_reading_wrangler) }
	let!(:wrangler_2) { FactoryBot.create(:cat_reading_wrangler) }

  it "happy path" do
    # Initiating a request
    #   * book request should be in initiated status
    #   * notifies all available wranglers
    expect{ ReadingRequests::Initiate.call(cat: kitty, request_data: request_data) }
      .to change{ kitty.book_requests.count }
      .by(1) # initiating a reading request should only create one book request for cat
      .and change{ ActionMailer::Base.deliveries.count }
      .by(2) # the number of available wranglers

    # Accepting a request
    #   * a wrangler can accept an initiated request
    #   * accepting a request logs the accepted_at date
    #   * and upates the status to accepted
    #   * updates the book request delivery date
    #   * notifies the cat of the delivery date

    # Cancel a request
    #   * a request can be canceled up until it's checked out
    #   * checkout is the point of no return!

    # Checking Out from the Library
    #   * creates books if they're not in our system yet
    #   * creates a checkout
    #   * creates a book checkout for each book checked out
    #     recording the date, action, and condition of the book

    # Delivery to the Cat
    #   * logs the delivered at
    #   * updates the status

    # Pick up from the Cat
    #   * logs the picked up at
    #   * updates the status

    # Return to the Library
    #   * updates the checkout
    #   * creates a book checkout to log condition and return date
  end
end