class ApplicationController < ActionController::Base
  FILTERED_PARAMS = Rails.application.config.filter_parameters.map(&:to_s).freeze

  def audit_user_action
    @start_time = Time.now
    @action_severity = :info

    if current_user.blank?
      # if there is no current user, just run the controller
      yield
      return
    end

    user_action = current_user.user_actions.new(
      ip_address: request.remote_ip,
      action: request.method.downcase
    )
    the_params = params.clone.to_unsafe_h
    data = {}

    data[:start_time] = @start_time.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
    data[:controller] = the_params["controller"]
    data[:controller_action] = the_params["action"]
    data[:kind] = "user_action"
    data[:host] = request.host
    data[:path] = request.path
    data[:is_https] = request.ssl?
    data[:git_hash] = GIT_COMMIT_LONG
    data[:user_agent] = request.user_agent

    data[:parameters] = the_params.except("controller", "action", "format", "utf8", "authenticity_token")
    data[:parameters].except!(FILTERED_PARAMS)

    begin
      yield
    rescue => e
      puts e.message
      data["error"] = e.message
    ensure
      user_action.assign_attributes(
        response_code: response.status
      )

      data[:response_format] = response.media_type
    end

    user_action.assign_attributes(
      severity: @action_severity
    )
    data[:response_format] = "turbo_frame" if turbo_frame_request?
    end_time = Time.now

    data[:end_time] = end_time.strftime("%Y-%m-%dT%H:%M:%S.%L%z")

    @action_duration = (end_time - @start_time) * 1000
    data[:duration] = @action_duration

    Thread.new do
      begin
        user_action.save!
        # puts "Saved user action"
      rescue => e
        puts "Failed to save user action"
        puts e.message
      end
    end

    actual_duration = (Time.now - @start_time) * 1000
    Rails.logger.info "Actual Duration: #{actual_duration}" if Rails.env.development?

    # duration difference is the difference between the actual duration and the duration we recorded
    # tells us how long it took to spin up a new thread and publish the data
    actual_duration_difference = actual_duration - @action_duration
    Rails.logger.info "Duration Difference: #{actual_duration_difference}" if Rails.env.development?
  end

end
