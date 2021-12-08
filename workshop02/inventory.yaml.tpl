all:
  vars:
    ansible_user: root
    ansible_connection: ssh
    ansible_ssh_private_key_file: ./mykey

  hosts:
  
    myserver-0:
      ansible_host: ${host}
      mysql_root_password: ${mysqlpassword}