use t::WASM 'no_plan';

run_tests();

__DATA__

=== TEST 1: get_property (host)
--- config
location /t {
    content_by_lua_block {
        local test_cases = {
            "scheme", "host", "uri", "arg_test", "request_uri",
        }

        local wasm = require("resty.proxy-wasm")
        local plugin = wasm.load("plugin", "t/testdata/property/main.go.wasm")
        for _, case in ipairs(test_cases) do
            local plugin_ctx, err = wasm.on_configure(plugin, case)
            assert(wasm.on_http_request_headers(plugin_ctx))
        end
    }
}
--- request
GET /t?test=yeah
--- error_log
get property: scheme = http
get property: host = localhost
get property: uri = /t
get property: arg_test = yeah
get property: request_uri = /t?test=yeah
