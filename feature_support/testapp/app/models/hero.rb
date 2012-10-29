class Hero < User
  
  def stun_international_crowd!
    self.biography = "Magico!, Fantastico!, Fantastique!, Marvelous!, Marveloso!!, Magnifique!, (speachless), Fantastisch!, supergut!"
    self.save!
  end
  
end