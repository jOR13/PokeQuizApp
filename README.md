# Pokémon Quiz App

## Description

Pokémon Quiz App is an interactive quiz application about Pokémon, generating automatic questions using the OpenAI API. Players can answer questions about Pokémon types, colors, and abilities, with adjustable difficulty levels.

## Features

- Automatic question generation using OpenAI and the PokeAPI.
- Multiple difficulty levels: easy, medium, and hard.
- Game mode with and without AI if this option is enabled, the AI will help to generate complex questions.
- Scoring system and player ranking.
- Simple and user-friendly interface.
- API for retrieving the participants and the results.

## Pending Features

- Share the results to social media
- Add Dark Mode to GUI
- User Authentication

## API Access

- Visit the api docs in .../api-docs
- Endpoint API players .../api/players

## Installation

- Clone the repository:
```bash
   git clone https://github.com/jOR13/PokeQuizApp.git
   cd pokemon-quiz-app
```
- Install dependencies:
```bash
   bundle install
```
- Set up the database:
```bash
   rails db:create
   rails db:migrate
```
- Install and configure the OpenAI API key:
  - Create an account on OpenAI and get an API key.
  - Create a `.env` file in the root directory of the project.
  - Add the following line to the `.env` file:
  ```bash
     OPENAI_API_KEY=your_api_key_here
  ```

- Run the server:
```bash
   rails server
```
- Access the app in your web browser at http://localhost:3000.

## Testing

To run the test suite, use:
```bash
   rails test
```
To see the coverage report, open the `open coverage/index.html` file in your web browser.


### Prerequisites

- Ruby 3.3.1
- Rails 7.1.3
- PostgreSQL (for the database)

## Linting

To run RuboCop for code linting, use:
bundle exec rubocop

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For any inquiries, please contact jesus.ochoa.rabelo@gmail.com
