resource "aws_instance" "instance" {
    count                       = var.instance_count
    ami                         = var.ami
    instance_type               = var.instance_type
    iam_instance_profile        = aws_iam_instance_profile.ec2_roles_instance_profile.name
    key_name                    = "daniels-key-to-my-heart"

    network_interface {
      device_index              = 0
      network_interface_id      = aws_network_interface.network_interface[count.index].id
    }   

    tags                        = {
        Name                    = "${var.environment}_instance_${count.index + 1}"
    }
    
    user_data = data.template_file.init_script.rendered
}
