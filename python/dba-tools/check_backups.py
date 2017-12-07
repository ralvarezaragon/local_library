import os
import datetime
import itertools
import socket


def get_file_list(root_dir):
  file_l = []
  for root, subfolders, files in os.walk(root_dir):
    for file in files:
      file_detail = dict()
      # print "{0}".format(os.path.join(root, file))
      raw_str = file.split("_")
      raw_date = raw_str[1].split(".tar")
      raw_date = raw_date[0]
      bkp_date = datetime.datetime.strptime(raw_date, "%Y.%m.%d")
      # print bkp_date
      file_detail['file_path'] = os.path.join(root, file)
      file_detail['file_date'] = bkp_date
      file_detail['cluster'] = raw_str[0]
      file_l.append(file_detail)
  return file_l

def get_last_bkp_date(file_l):
  res_l = []
  for key, group in itertools.groupby(file_l, lambda item: item["cluster"]):
    last_bkp = dict()
    last_bkp['cluster'] = key
    last_bkp['bkp_date'] = max([item["file_date"] for item in group])
    last_bkp['bkp_date'] = last_bkp['bkp_date'].strftime('%d (%A) %b %Y')
    res_l.append(last_bkp)
  return res_l

def send_slack_msg(msg):
  url = "https://hooks.slack.com/services/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"
  cmd = 'curl -s -d "payload={0}" "{1}"'.format(msg, url)
  os.system(cmd)

root_dir = '/remote/percona'
hostname = socket.gethostname()
file_l = get_file_list(root_dir)
res_l = get_last_bkp_date(file_l)
res_l_tmp = []
res_l_tmp.append('{0} last files:'.format(hostname))
for res in res_l:
  res_tmp = "{0} => {1}".format(res['cluster'], res['bkp_date'])
  res_l_tmp.append(res_tmp)

res_str = "\n".join(res_l_tmp)
msg_json = "{'channel': 'dba-utils', 'text': '"+res_str+"'}"
send_slack_msg(msg_json)



#for res in res_l:
#  print(res['cluster'], res['bkp_date'].strftime('%d (%A) %b %Y'))




