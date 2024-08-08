class QuizContentGenerator
    def initialize(level)
      @level = level
    end
  
    def generate
      questions = []


    case @level
        when "easy"
            questions_quantity = 3
        when "medium"
            questions_quantity = 5
        when "hard"
            questions_quantity = 7
    end
            
    questions_quantity.times do
        pokemon = fetch_random_pokemon
        questions << generate_question(pokemon)
      end
  
      { questions: questions }
    end
  
    private
  
    def fetch_random_pokemon
      response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{rand(1..151)}")
      JSON.parse(response.body)
    end
  
    def generate_question(pokemon)
      {
        question: "What is the type of #{pokemon['name']}?",
        options: pokemon['types'].map { |type| type['type']['name'] },
        answer: pokemon['types'][0]['type']['name'],
        player_answer: nil
      }
    end
  end
  