require 'rack/webconsole'

module Rack
  class Webconsole
    class Sandbox

      def switch_runtime(name)
        runtime = TorqueBox::Webconsole.lookup_runtime(name)
        if runtime.nil?
          "runtime #{name} not found"
        else
          web_runtime = TorqueBox::Webconsole.web_runtime[0]
          web_runtime.evaluate <<-EOS
            runtime = TorqueBox::Webconsole.lookup_runtime(%q(#{name}))
            $runtime = runtime
          EOS
          "switched to #{name} runtime"
        end
      end

      def list_runtimes
        TorqueBox::Webconsole.list_runtimes
      end

      def current_runtime
        web_runtime = TorqueBox::Webconsole.web_runtime[0]
        web_runtime.evaluate "$runtime[1]"
      end

      def help
        "Welcome to the TorqueBox webconsole. It's rack-webconsole with the following " +
          "additions: * list_runtimes - returns list of all of the TorqueBox runtimes " +
          "for the current application. * switch_runtime(name) - switch " +
          "your execution context to a different runtime. * current_runtime - returns " +
          "the name of the current runtime."
      end
    end

    class Repl
      
      def call(env)
        status, headers, response = @app.call(env)

        req = Rack::Request.new(env)
        params = req.params

        return [status, headers, response] unless check_legitimate(req)
        $runtime ||= TorqueBox::Webconsole.web_runtime
        query = params['query']
        response_body = $runtime[0].evaluate("Rack::Webconsole::Repl.eval_query(%q(#{query}))")
        headers = {}
        headers['Content-Type'] = 'application/json'
        headers['Content-Length'] = response_body.bytesize.to_s
        [200, headers, [response_body]]
      end

      def self.eval_query(query)
        $sandbox ||= Sandbox.new
        hash = Shell.eval_query(query)
        MultiJson.encode(hash)
      end
      
    end
  end
end
