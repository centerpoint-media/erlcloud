-module(erlcloud_ml).

%%% Library initialization.

-export([
  predict/0,
  predict/1
]).

-include("erlcloud.hrl").
-include("erlcloud_aws.hrl").

predict() ->
  timer:tc(?MODULE, predict,
  %predict([
  [[
            {<<"bid">>, <<"5">>}, 
            {<<"domain">>, <<"cnn.com">>}, 
            {<<"lid">>, <<"1321789">>}, 
            {<<"floor">>, <<"5">>}, 
            {<<"ip">>, <<"53.32.122.32">>}, 
            {<<"price">>, <<"5">>}]]).

-spec predict([{binary(), binary()}]) -> non_neg_integer().
predict(Params) ->
  Json = 
  %{"MLModelId": ml-L97W74WlF66,
   %"Record": {"bid": "5", "domain": "cnn.com", "lid": "1321789", "floor": "5", "ip": "53.32.122.32", "price": "5"

  Json = [{<<"MLModelId">>, <<"ml-L97W74WlF66">>}, 
          {<<"PredictEndpoint">>, <<"https://realtime.machinelearning.us-east-1.amazonaws.com">>},
          %{<<"Record">>, [{<<"bid">>, <<"5">>}]}],
          {<<"Record">>, Params}],
  
  % E.g.
  % {ok,[{<<"Prediction">>,
  %       [{<<"details">>,
  %         [{<<"Algorithm">>,<<"SGD">>},
  %          {<<"PredictiveModelType">>,<<"BINARY">>}]},
  %        {<<"predictedLabel">>,<<"1">>},
  %        {<<"predictedScores">>,[{<<"1">>,0.13679121434688568}]}]}]}

  case erlcloud_ml_impl:request(default_config(), "AmazonML_20141212.Predict", Json) of
    {ok, [{<<"Prediction">>, Result}]} ->
      Label = proplists:get_value(<<"predictedLabel">>, Result),
      {predicted_label, Label};
    Err ->
      Err
  end.

default_config() -> erlcloud_aws:default_config().

