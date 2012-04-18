require 'rack/webconsole'

module Rack
  class Webconsole
    class Sandbox

      def switch_runtime(name, app = nil)
        runtime = TorqueBox::Webconsole.lookup_runtime(name, app)
        if runtime.nil?
          msg = "runtime #{name} not found"
          msg << " for app #{app}" if app
          msg
        else
          web_runtime = TorqueBox::Webconsole.web_runtime[0]
          web_runtime.evaluate <<-EOS
            runtime = TorqueBox::Webconsole.lookup_runtime(%q(#{name}))
            $runtime = runtime
          EOS
          "switched to #{current_runtime}"
        end
      end

      def list_runtimes
        TorqueBox::Webconsole.list_runtimes.map { |x| TorqueBox::Webconsole.runtime_metadata(x) }
      end

      def current_runtime
        TorqueBox::Webconsole.runtime_metadata($runtime[1..-1])
      end

      def help
        "Welcome to the TorqueBox webconsole. It's rack-webconsole with the following " +
          "additions: * list_runtimes - returns list of all of the TorqueBox runtimes " +
          "along with their app names. * switch_runtime(name[, app_name]) - switch " +
          "your execution context to a different runtime. If the app_name isn't " +
          "provided, it will attempt to switch to the given runtime within the current " +
          "application. * current_runtime - returns the name and app name of the " +
          "current runtime."
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
