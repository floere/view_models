Application.controller :examples do
  get :index do
    @items = Items.all
    render 'examples/index'
  end
end