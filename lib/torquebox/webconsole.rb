require "torquebox/webconsole/version"
require 'torquebox/webconsole/rack-webconsole-patch'
require 'java'
require 'torquebox'

module TorqueBox
  class Webconsole
    class << self
      
      def lookup_runtime(name)
        service_registry = TorqueBox.fetch('service-registry')
        unit = TorqueBox.fetch('deployment-unit')
        
        service_name = org.torquebox.core.as.CoreServices.runtimePoolName(unit, name)
        service_controller = service_registry.get_service(service_name)
        
        return nil unless service_controller
        pool = service_controller.service.value
        pool.evaluate "require 'torquebox/webconsole'"
        
        [pool, name]
       end

      def web_runtime
        lookup_runtime('web')
      end

      def list_runtimes
        prefix = TorqueBox.fetch('deployment-unit').
          service_name.
          append(org.torquebox.core.as.CoreServices::RUNTIME).
          append("pool").
          canonical_name
        
        TorqueBox.fetch('service-registry').service_names.to_a.map do |x|
          $1 if x.canonical_name =~ %r{#{prefix}\.([^.]+)$}
        end.reject(&:nil?)
      end

    end
  end
end
