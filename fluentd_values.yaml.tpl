fileConfigs:
  01_sources.conf: |-
    <source>
      @type tail
      @id tail_var_logs
      @label @CORALOGIX
      path /var/logs/*.log
      pos_file /var/logs/all.pos
      tag all
      read_from_head true
      <parse>
        # Can be other types as mentioned in docs
        # https://docs.fluentd.org/configuration/parse-section
        @type json
      </parse>
    </source>

  02_filters.conf: |-
  03_dispatch.conf: ""
  04_outputs.conf: |-
    <label @CORALOGIX>
      <filter **>
      @type record_transformer
      @log_level warn
      enable_ruby true
      auto_typecast true
      renew_record true
      <record>
        # In this example we are using record.dig to dynamically set values.
        # Values can also be static or simple variables
        applicationName $${record.dig("kubernetes", "namespace_name")}
        subsystemName $${record.dig("kubernetes", "container_name")}
        computerName $${record.dig("kubernetes", "host")}
        timestamp $${time.strftime('%s%L')} # Optional
        text $${record.to_json}
      </record>
      </filter>

    <match **>
      @type http
      @id http_to_coralogix
      endpoint "https://api.coralogix.com/logs/rest/singles"
      headers {"private_key":"${private_key}"}
      retryable_response_codes 503
      error_response_as_unrecoverable false
      <buffer>
        @type memory
        chunk_limit_size 5MB
        compress gzip
        flush_interval 1s
        overflow_action block
        retry_max_times 5
        retry_type periodic
        retry_wait 2
      </buffer>
      <secondary>
        #If any messages fail to send they will be send to STDOUT for debug.
        @type stdout
      </secondary>
    </match>
    </label>


