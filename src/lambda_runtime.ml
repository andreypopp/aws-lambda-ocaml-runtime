
let start_with_runtime_client handler function_config client =
  let runtime = Runtime.make ~handler ~max_retries:3 ~settings:function_config client
  in Runtime.start runtime

let setup_log ?style_renderer level =
  Fmt_tty.setup_std_outputs ?style_renderer ();
  Logs.set_level level;
  Logs.set_reporter (Logs_fmt.reporter ());
  ()

let start handler =
  setup_log (Some Logs.Debug);
  match Config.get_runtime_api_endpoint() with
  | Ok endpoint ->
    begin match Config.get_function_settings() with
    | Ok function_config ->
      let client = Client.make(endpoint) in
       start_with_runtime_client handler function_config client
    | Error msg -> failwith msg
    end
  | Error msg -> failwith msg
