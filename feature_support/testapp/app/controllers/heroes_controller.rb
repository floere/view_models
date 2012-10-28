class HeroesController < UsersController
  def show
    @guy = Hero.find params[:id]
    render
  end
end