shared_examples_for 'forbidden response' do
  it 'has status 403' do
    request
    expect(response.status).to eq 403
  end
end