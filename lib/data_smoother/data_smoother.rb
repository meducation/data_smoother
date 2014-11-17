module DataSmoother
  class DataSmoother


    def self.smooth(start_date, end_date, input_data, extrapolate = false)

      #work out ten intervals

      diff = end_date - start_date
      interval = diff / 9
      labels = (0..9).map do |i|
        start_date + (interval * i)
      end
      output = {
          labels: labels,
          ideal_score: [1, 4, 9, 16, 25, 36, 49, 64, 81, 100],
          data: []
      }

      #work out closest inputs
      output[:labels].each_with_index do |label, i|
        distances = input_data.map { |date, score| {date: date, score: score, distance: (label - date).abs.to_i} }
        distances.keep_if { |e| e[:distance] < (interval / 2) }
        # puts distances
        avg_score = distances.inject(0) { |sum, e| sum += e[:score] } / (distances.length) unless distances.empty?
        avg_score = nil if distances.empty?
        output[:data][i] = {score: avg_score}
        output[:data][i][:input_used] = distances unless distances.empty?
      end

      improvements = []
      output[:data].each_cons(2) do |left, right|
        improvements << right[:score] - left[:score] unless left[:score].nil? || right[:score].nil?
      end

      avg_improvement = improvements.inject(:+) / improvements.length

      #extrapolate
      if extrapolate
        output[:data].each_cons(2) do |left, right|
          if right[:score].nil?
            right[:score] = [(left[:score] + avg_improvement), 100].min
            right[:extrapolated] = true
          end
        end
      end

      return output

    end


  end
end