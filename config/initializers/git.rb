# frozen_string_literal: true

GIT_COMMIT_SHORT = `git rev-parse --short HEAD`.chomp
GIT_COMMIT_LONG = `git rev-parse HEAD`.chomp
