require "torquebox/webconsole/version"
require 'torquebox/webconsole/rack-webconsole-patch'
require 'java'
require 'torquebox'

module TorqueBox
  class Webconsole
    extend TorqueBox::Injectors
    class << self

      def lookup_runtime(name, app = nil)
        service_registry = inject('service-registry')
        service_name = nil
        
        if app
          _, _, service_name = list_runtimes.detect { |v| v[0] == app && v[1] == name }
        else
          unit = inject('deployment-unit')
          service_name = org.torquebox.core.as.CoreServices.runtimePoolName(unit, name)
        end

        return nil unless service_name
        service_controller = service_registry.get_service(service_name)
        return nil unless service_controller
        pool = service_controller.service.value
        
        pool.evaluate """
        require 'rack/webconsole'
        require 'torquebox-webconsole'
      """
        [pool] + parse_pool_name(service_name)
      end

      def web_runtime
        lookup_runtime('web')
      end

      def list_runtimes
        service_registry = inject('service-registry')
        service_registry.service_names.to_a.map { |x| parse_pool_name(x) }.reject(&:nil?)
      end

      def parse_pool_name(service_name)
        [$1, $3, service_name] if service_name.canonical_name =~
          /"(.*)(-knob\.yml|\.knob)"\.torquebox\.core\.runtime\.pool\.([^.]+)$/
      end

      def runtime_metadata(runtime)
        { :app => runtime[0], :name => runtime[1] }
      end
    end
  end
end
