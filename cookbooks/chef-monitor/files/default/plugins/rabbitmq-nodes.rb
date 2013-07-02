#!/usr/bin/env ruby

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'
require 'json'
require 'rest_client'

class CheckRabbitMQ < Sensu::Plugin::Check::CLI

  option :host,
    :description => "RabbitMQ host",
    :short => '-w',
    :long => '--host HOST',
    :default => 'localhost'

  option :username,
    :description => "RabbitMQ username",
    :short => '-u',
    :long => '--username USERNAME',
    :default => 'guest'

  option :password,
    :description => "RabbitMQ password",
    :short => '-p',
    :long => '--password PASSWORD',
    :default => 'guest'

  option :port,
    :description => "RabbitMQ API port",
    :short => '-P',
    :long => '--port PORT',
    :default => '55672'

  option :mem_threshold,
    :description => "The maximum allowable ratio between used memory and the rabbitmq limit, expressed as a percentage",
    :short => '-m',
    :long => '--mem_threshold MEM_THRESHOLD',
    :default => '75'

  option :fd_threshold,
    :description => "The maximum allowable ratio between used file descriptors and the rabbitmq limit, expressed as a percentage",
    :short => '-f',
    :long => '--fd_threshold FD_THRESHOLD',
    :default => '75'

  option :sockets_threshold,
    :description => "The maximum allowable ratio between used sockets and the rabbitmq limit, expressed as a percentage",
    :short => '-s',
    :long => '--sockets_threshold SOCKETS_THRESHOLD',
    :default => '75'

  option :disk_threshold,
    :description => "The maximum allowable ratio between used disk space and the rabbitmq limit, expressed as a percentage",
    :short => '-d',
    :long => '--disk_threshold DISK_THRESHOLD',
    :default => '75'

  option :proc_threshold,
    :description => "The maximum allowable ratio between the current process count and the rabbitmq limit, expressed as a percentage",
    :short => '-w',
    :long => '--proc_threshold PROC_THRESHOLD',
    :default => '75'

  def run
    res = node_resources?

    if res["status"] == "ok"
      ok res["message"]
    elsif res["status"] == "critical"
      critical res["message"]
    else
      unknown res["message"]
    end
  end

  def node_resources?
    host       = config[:host]
    port       = config[:port]
    username   = config[:username]
    password   = config[:password]
    mem_threshold = config[:mem_threshold]
    fd_threshold = config[:fd_threshold]
    sockets_threshold = config[:sockets_threshold]
    disk_threshold = config[:disk_threshold]
    proc_threshold = config[:proc_threshold]

    begin
      fault = false
      msg = ""
      resource = RestClient::Resource.new "http://#{host}:#{port}/api/nodes", username, password
      JSON.parse(resource.get).each do |node|
        msg += "#{node['name']}"

        if !node['running']
            fault = true
            msg += " NOT RUNNING"
            next
        end

        if node['mem_alarm']
            fault = true
            msg += " MEMORY:ALARM"
        else
            used_mem = (node['mem_used'].to_f / node['mem_limit'].to_f * 100).round(2)
            if used_mem >= mem_threshold.to_f
                fault = true
                msg += " MEMORY:#{used_mem.to_s}%"
            else
                msg += " memory:#{used_mem.to_s}%"
            end
        end

        used_fd = (node['fd_used'].to_f / node['fd_total'].to_f * 100).round(2)
        if used_fd >= fd_threshold.to_f
            fault = true
            msg += " FD:#{used_fd.to_s}%"
        else
            msg += " fd:#{used_fd.to_s}%"
        end

        used_sockets = (node['sockets_used'].to_f / node['sockets_total'].to_f * 100).round(2)
        if used_sockets >= sockets_threshold.to_f
            fault = true
            msg += " SOCKETS:#{used_sockets.to_s}%"
        else
            msg += " sockets:#{used_sockets.to_s}%"
        end

        if node['disk_free_alarm']
            fault = true
            msg += " DISK:ALARM"
        else
            remaining = (node['disk_free_limit'].to_f / node['disk_free'].to_f * 100).round(2)
            if remaining >= disk_threshold.to_f
                fault = true
                msg += " DISK:#{remaining.to_s}%"
            else
                msg += " disk:#{remaining.to_s}%"
            end
        end

        used_procs = (node['proc_used'].to_f / node['proc_total'].to_f * 100).round(2)
        if used_procs >= proc_threshold.to_f
            fault = true
            msg += " PROCS:#{used_procs.to_s}%"
        else
            msg += " procs:#{used_procs.to_s}%"
        end

        msg +="; "
      end
      if fault
         { "status" => "critical", "message" => msg }
      else
         { "status" => "ok", "message" => msg }
      end
    rescue Errno::ECONNREFUSED => e
      { "status" => "critical", "message" => e.message }
    rescue Exception => e
      { "status" => "unknown", "message" => e.message }
    end
  end
end
