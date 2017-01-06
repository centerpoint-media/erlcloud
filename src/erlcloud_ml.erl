-module(erlcloud_ml).

%%% Library initialization.

-export([
  predict/0,
  predict/1
]).

-include("erlcloud.hrl").
-include("erlcloud_aws.hrl").

predict() ->
  timer:tc(?MODULE, predict, [[
    {<<"Var01">>, <<"123">>}, % {<<"crid">>, <<"123">>},
    {<<"Var02">>, <<"cnn.com">>}, % {<<"domain">>, <<"cnn.com">>},
    {<<"Var03">>, <<"1321789">>}, % {<<"lid">>, <<"1321789">>},
    {<<"Var04">>, <<"large">>}, % {<<"playersize">>, <<"large">>},
    {<<"Var05">>, <<"53.32.122.32">>}, % {<<"ip">>, <<"53.32.122.32">>},
    {<<"Var06">>, <<"a">>}, % {<<"device">>, <<"a">>},
    {<<"Var07">>, <<"b">>}, % {<<"os">>, <<"b">>},
    {<<"Var08">>, <<"en">>}, % {<<"lang">>, <<"en">>},
    {<<"Var09">>, <<"234">>}, % {<<"sid">>, <<"234">>},
    {<<"Var10">>, <<"345">>}, % {<<"pubid">>, <<"345">>},
    {<<"Var11">>, <<"false">>}, % {<<"userid">>, <<"456">>},
    {<<"Var12">>, <<"567">>}, % {<<"aid">>, <<"567">>},
    {<<"Var13">>, <<"5">>} % {<<"floor">>, <<"5">>}
  ]]).

-spec predict([{binary(), binary()}]) -> non_neg_integer().
predict(Params) ->
  Json =
    %{"MLModelId": ml-L97W74WlF66,
  %"Record": {"bid": "5", "domain": "cnn.com", "lid": "1321789", "floor": "5", "ip": "53.32.122.32", "price": "5"

  %Json = [{<<"MLModelId">>, <<"ml-L97W74WlF66">>},
  Json = [{<<"MLModelId">>, <<"ml-lyQ4THupSXn">>},
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
      Value = proplists:get_value(<<"predictedValue">>, Result),
      {predicted_value, Value};
    Err ->
      Err
  end.

default_config() -> erlcloud_aws:default_config().
