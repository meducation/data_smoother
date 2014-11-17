require 'data_smoother'
# require 'date'
require 'minitest/autorun'
# require "minitest/pride"

module DataSmoother
  class DataSmootherTest < Minitest::Test

    def test_basic_smoothing

      input_data = {
          DateTime.new(2014, 1, 1, 0, 0, 0) => 27,
          DateTime.new(2014, 2, 1, 0, 0, 0) => 37,
          DateTime.new(2014, 3, 1, 0, 0, 0) => 47,
          DateTime.new(2014, 4, 1, 0, 0, 0) => 57
      }

      expected_data = {
          labels: [
              DateTime.new(2014,  1,  1,  0, 0, 0),
              DateTime.new(2014,  1, 31,  8, 0, 0),
              DateTime.new(2014,  3,  2, 16, 0, 0),
              DateTime.new(2014,  4,  2,  0, 0, 0),
              DateTime.new(2014,  5,  2,  8, 0, 0),
              DateTime.new(2014,  6,  1, 16, 0, 0),
              DateTime.new(2014,  7,  2,  0, 0, 0),
              DateTime.new(2014,  8,  1,  8, 0, 0),
              DateTime.new(2014,  8, 31, 16, 0, 0),
              DateTime.new(2014, 10,  1,  0, 0, 0),
          ],
          ideal_score: [1, 4, 9, 16, 25, 36, 49, 64, 81, 100],
          data: [
              {score: 27, input_used: [{date: DateTime.new(2014, 1, 1, 0, 0, 0), score: 27, distance: 0}]},
              {score: 37, input_used: [{date: DateTime.new(2014, 2, 1, 0, 0, 0), score: 37, distance: 0}]},
              {score: 47, input_used: [{date: DateTime.new(2014, 3, 1, 0, 0, 0), score: 47, distance: 1}]},
              {score: 57, input_used: [{date: DateTime.new(2014, 4, 1, 0, 0, 0), score: 57, distance: 1}]},
              {score: nil},
              {score: nil},
              {score: nil},
              {score: nil},
              {score: nil},
              {score: nil}
          ]}


      start_date = DateTime.new(2014, 1, 1, 0, 0, 0)
      end_date = DateTime.new(2014, 10, 1, 0, 0, 0)
      actual_data = DataSmoother.smooth(start_date, end_date, input_data)
      assert_equal expected_data, actual_data
    end

    def test_extrapolated_smoothing_with_dates

      expected_data = {
          labels: [
              Date.new(2014, 1, 1),
              Date.new(2014, 1, 1) + (1 * Rational(91, 3)),
              Date.new(2014, 1, 1) + (2 * Rational(91, 3)),
              Date.new(2014, 1, 1) + (3 * Rational(91, 3)),
              Date.new(2014, 1, 1) + (4 * Rational(91, 3)),
              Date.new(2014, 1, 1) + (5 * Rational(91, 3)),
              Date.new(2014, 1, 1) + (6 * Rational(91, 3)),
              Date.new(2014, 1, 1) + (7 * Rational(91, 3)),
              Date.new(2014, 1, 1) + (8 * Rational(91, 3)),
              Date.new(2014, 1, 1) + (9 * Rational(91, 3)),
          ],
          ideal_score: [1, 4, 9, 16, 25, 36, 49, 64, 81, 100],
          data: [
              {score: 0, input_used: [{date: Date.new(2014, 1, 1), score: 0, distance: 0}]},
              {score: 0, extrapolated: true},
              {score: 0, extrapolated: true},
              {score: 0, extrapolated: true},
              {score: 0, extrapolated: true},
              {score: 0, extrapolated: true},
              {score: 0, extrapolated: true},
              {score: 0, extrapolated: true},
              {score: 0, extrapolated: true},
              {score: 0, extrapolated: true}
          ]}


      actual_data = DataSmoother.smooth(Date.new(2014,1,1), Date.new(2014,10,1), {Date.new(2014,1,1) => 0}, true)
      assert_equal expected_data, actual_data
    end

    def test_extrapolated_smoothing

      input_data = {
          DateTime.new(2014, 1, 1, 0, 0, 0) => 27,
          DateTime.new(2014, 2, 1, 0, 0, 0) => 37,
          DateTime.new(2014, 3, 1, 0, 0, 0) => 47,
          DateTime.new(2014, 4, 1, 0, 0, 0) => 57
      }

      expected_data = {
          labels: [
              DateTime.new(2014,  1,  1,  0, 0, 0),
              DateTime.new(2014,  1, 31,  8, 0, 0),
              DateTime.new(2014,  3,  2, 16, 0, 0),
              DateTime.new(2014,  4,  2,  0, 0, 0),
              DateTime.new(2014,  5,  2,  8, 0, 0),
              DateTime.new(2014,  6,  1, 16, 0, 0),
              DateTime.new(2014,  7,  2,  0, 0, 0),
              DateTime.new(2014,  8,  1,  8, 0, 0),
              DateTime.new(2014,  8, 31, 16, 0, 0),
              DateTime.new(2014, 10,  1,  0, 0, 0),
          ],
          ideal_score: [1, 4, 9, 16, 25, 36, 49, 64, 81, 100],
          data: [
              {score: 27, input_used: [{date: DateTime.new(2014, 1, 1, 0, 0, 0), score: 27, distance: 0}]},
              {score: 37, input_used: [{date: DateTime.new(2014, 2, 1, 0, 0, 0), score: 37, distance: 0}]},
              {score: 47, input_used: [{date: DateTime.new(2014, 3, 1, 0, 0, 0), score: 47, distance: 1}]},
              {score: 57, input_used: [{date: DateTime.new(2014, 4, 1, 0, 0, 0), score: 57, distance: 1}]},
              {score: 67, extrapolated: true},
              {score: 77, extrapolated: true},
              {score: 87, extrapolated: true},
              {score: 97, extrapolated: true},
              {score: 100, extrapolated: true},
              {score: 100, extrapolated: true}
          ]}


      start_date = DateTime.new(2014, 1, 1, 0, 0, 0)
      end_date = DateTime.new(2014, 10, 1, 0, 0, 0)
      actual_data = DataSmoother.smooth(start_date, end_date, input_data, true)
      assert_equal expected_data, actual_data
    end


  end

end