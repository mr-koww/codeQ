shared_examples_for 'publishable' do
  it 'publishes to channel' do
    expect(PrivatePub).to receive(:publish_to).with(channel, anything)
    request
  end
end

shared_examples_for 'not publishable' do
  it 'not publishes to channel' do
    expect(PrivatePub).to_not receive(:publish_to).with(channel, anything)
    bad_request
  end
end