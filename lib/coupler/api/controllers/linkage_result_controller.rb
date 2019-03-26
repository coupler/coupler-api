module Coupler::API
  class LinkageResultController < Controller
    def initialize(show, matches, show_params, matches_params)
      @show = show
      @matches = matches
      @show_params = show_params
      @matches_params = matches_params
    end

    def self.dependencies
      [ 'LinkageResults::Show', 'LinkageResults::Matches',
        'LinkageResultParams::Show', 'LinkageResultParams::Matches' ]
    end

    def show(req, res)
      params = @show_params.process({ 'id' => req['linkage_result_id'] })
      @show.run(params)
    end

    def matches(req, res)
      data = {
        'id' => req['linkage_result_id'],
        'match_index' => req['match_index']
      }
      params = @matches_params.process(data)
      @matches.run(params)
    end
  end
end
