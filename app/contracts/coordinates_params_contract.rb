class CoordinatesParamsContract < Dry::Validation::Contract

  params do
    required(:id).filled(:string)
    required(:lat).filled(:string)
    required(:lon).filled(:string)
  end

end
