# frozen_string_literal: true

module QuestionConstants
  INCORRECT_ANSWERS_EN = %w[water fire grass flying psychic dark ground rock electric steel ice dragon
                            fairy].map(&:downcase)
  INCORRECT_ANSWERS_ES = %w[agua fuego hierba volador psíquico oscuro tierra roca eléctrico acero hielo dragón
                            hada].map(&:downcase)
  INCORRECT_COLORS_EN = %w[red blue yellow green black white purple pink brown gray orange].map(&:downcase)
  INCORRECT_COLORS_ES = %w[rojo azul amarillo verde negro blanco morado rosa marrón gris naranja].map(&:downcase)
  INCORRECT_ABILITIES_EN = %w[overgrow blaze torrent shield dust static inner focus intimidate flash
                              fire].map(&:downcase)
  INCORRECT_ABILITIES_ES = %w[espesura mar llamas torrente polvo escudo estático enfoque interno intimidación fuego
                              interno].map(&:downcase)

  INCORRECT_EVOLUTIONS_EN = ['charizard', 'bulbasaur', 'squirtle', 'pikachu', 'eevee', 'meowth', 'jigglypuff',
                             'psyduck', 'No more evolutions'].map(&:downcase)
  INCORRECT_EVOLUTIONS_ES = ['charizard', 'bulbasaur', 'squirtle', 'pikachu', 'eevee', 'meowth', 'jigglypuff',
                             'psyduck', 'No tiene más evoluciones'].map(&:downcase)
end
