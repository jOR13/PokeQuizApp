require 'test_helper'

class QuizContentGeneratorTest < ActiveSupport::TestCase
  def setup
    @generator = QuizContentGenerator.new('easy', false)
  end

  test 'should generate correct number of questions for easy level' do
    content = @generator.generate
    assert_equal 3, content[:questions].size
  end

  test 'should generate correct number of questions for medium level' do
    @generator = QuizContentGenerator.new('medium', false)
    content = @generator.generate
    assert_equal 5, content[:questions].size
  end

  test 'should generate correct number of questions for hard level' do
    @generator = QuizContentGenerator.new('hard', false)
    content = @generator.generate
    assert_equal 7, content[:questions].size
  end
end
