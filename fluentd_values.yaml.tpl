fileConfigs:
  01_sources.conf: |-
    <source>
      @type tail
      @id tail_var_logs
      @label @TABNINE
      path /var/log/containers/*.log
      pos_file /var/log/containers.pos
      tag all
      read_from_head true
      <parse>
        @type none
      </parse>
    </source>

  02_filters.conf: ""
  03_dispatch.conf: ""
  04_outputs.conf: |-
    <label @TABNINE>
      <filter **>
      @type record_transformer
      @log_level warn
      enable_ruby true
      auto_typecast true
      renew_record true
      <record>
        # applicationName $${record.dig("kubernetes", "namespace_name")}
        applicationName organizations
        subsystemName $${record.dig("kubernetes", "container_name")}
        computerName $${record.dig("kubernetes", "host")}
        timestamp $${time.strftime('%s%L')} # Optional
        organizationId ${organization_id}
        text $${record.to_json}
      </record>
      </filter>

    <match **>
      @type http
      @id http_to_tabnine
      endpoint "https://logs-gateway.tabnine.com/elastic"
      headers {"x-organization-id":"${organization_id}","x-organization-secret":"${organization_secret}" }
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


