shared_examples_for "Searchable" do
  it 'renders show view' do
    do_request
    expect(response).to render_template :show
  end

  it 'sends OK status' do
    do_request
    expect(response).to have_http_status(200)
  end
end