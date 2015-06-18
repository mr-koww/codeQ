shared_examples_for 'success response' do
  it 'has 200 status' do
  request
  expect(response.status).to eq 200
  end
end

shared_examples_for 'redirect not auth user to login form' do
  it 'redirect to login form' do
    request
    expect(response).to redirect_to new_user_session_path
  end
end

shared_examples_for 'unauthorized response for not auth user' do
  it 'has status 401' do
    request
    expect(response.status).to eq 401
  end
end

shared_examples_for 'forbidden response' do
  it 'has status 403' do
    request
    expect(response.status).to eq 403
  end
end

shared_examples_for 'unproccesible response' do
  it 'has status 422' do
    bad_request
    expect(response.status).to eq 422
  end
end