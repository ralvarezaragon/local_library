#!/usr/bin/python
import paramiko


def replace_str(s, pat, repl):
  for element in pat:
    s = s.replace(element, repl)
  return s


key = paramiko.RSAKey.from_private_key_file("/home/ralvarez/.ssh/ralvarez_rsa", password='r@001982#RA')
server = "cs1.basebone.com"
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(server, username="ralvarez", pkey=key)


channel = ssh.invoke_shell()
ssh_stdout1 = channel.send("nodetool cfstats esme_history")
ssh_stdout2 = channel.send("cqlsh 10.0.2.11 -e 'DESCRIBE keyspaces';")

print ssh_stdout1


#ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("cqlsh 10.0.2.11 -e 'DESCRIBE keyspaces'; ")
#ks_result = ssh_stdout.read()
#repl_list = ["\n"]
#ks_result = replace_str(ks_result, repl_list, "")
#ks_list = ks_result.split(' ')
#ks_list = filter(None, ks_list) 
#for keyspace in ks_list:
#ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("nodetool cfstats esme_history")
#cfstats = ssh_stdout.read()
#print cfstats

