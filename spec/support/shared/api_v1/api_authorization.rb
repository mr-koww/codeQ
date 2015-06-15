shared_examples_for 'API should be authorization' do
  it 'returns status unauthorized if access_token is not provided' do
    request
    expect(response.status).to eq 401
  end

  it 'returns status unauthorized if access_token is invalid' do
    request(access_token: '12345')
    expect(response.status).to eq 401
  end
end