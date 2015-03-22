SimpleNavigation::Configuration.run do |navigation|
  instance_exec navigation, &HomePage::Navigation.code
end