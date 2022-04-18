# Add output variable for LaunchConfig Name

output "LC_Name" {
  value= aws_launch_configuration.Group9_Project_webserver.name
}
