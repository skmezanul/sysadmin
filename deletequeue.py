#!/usr/bin/python

import os
import socket
import re
from optparse import OptionParser
from subprocess import Popen

from_pattern = re.compile(r"\d+F\s+From:\s+<?(\S+)>?")

def file_to_msgdict(filename):
    if not os.path.exists(filename):
        return {}
    fd = open(filename, 'r')
    content = fd.readlines()
    fd.close()

    result = {}
    for i, line in enumerate((l.strip('\r\n\t ') for l in content)):
        if not line:
            continue

        if i == 0:
            result['mid'] = line[:-2]
        elif i == 1:
            result['user'] = line.split(' ')[0]
        elif i == 2:
            result['address'] = line.strip('<>')
        elif line[0] == "-":
            tokens = line[1:].split(' ')
            if len(tokens) == 2:
                result[tokens[0]] = tokens[1]
            elif len(tokens) == 1:
                result[tokens[0]] = True
        else:
            match = from_pattern.match(line)
            if match:
                result['from'] = match.group(1)
    if 'host_address' in result:
        result['host_address'] = '.'.join(result['host_address'].split('.')[-1])
    return result


def walk_spool(spooldir='/var/spool/exim/input'):
    if not os.path.exists(spooldir):
        raise IOError("spool directory missing, specify exim spool directory using --spooldir")

    for root, dirs, files in os.walk(spooldir):
        for f in files:
            if f[-2:] == '-H':
                yield root + '/' + f

def split_list(list, n):
    return [list[i:i+n] for i in range(0, len(list), n)]

if __name__ == "__main__":

    oparser = OptionParser()

    oparser.add_option('--user', dest='user', default=None,
                       help='Filter by sending user (includes all emails associated with an account')
    oparser.add_option('--address', dest='address', default=None,
                       help='Filter by "from" address (this can be a real address or an apparent address)')
    oparser.add_option('--sending-host', dest='host', default=None,
                       help='Filter by sending address (hostname, "helo" name, or ip)')
    oparser.add_option('--bounced', dest='bounced', action='store_true', default=False,
                       help='list all bouncing (includes all emails associated with an account')
    oparser.add_option('--remove', dest='remove', action='store_true', default=False,
                       help='Remove messages from the exim queue')
    oparser.add_option('--freeze', dest='freeze', action='store_true', default=False,
                       help='Freeze messages in the exim queue')

    (options, arg) = oparser.parse_args()

    if options.bounced:
        user = re.compile('mailnull')
        address = re.compile('^(?:Mailer-Daemon@.*)?$')
        host = None
    else:
        if options.user: 
            user = re.compile(options.user)
        else: 
            user = None
        if options.address:
            address = re.compile(options.address)
        else:
            address = None
        if options.host:
            host = re.compile(options.host)
        else:
            host = None

    result = []
    result_append = result.append

    def handle_results():
        if options.remove:
            for args in split_list(result, 500):
                cmd = ['exim', '-Mrm']
                cmd.extend(args)
                proc = Popen(cmd)
                proc.wait()
        elif options.freeze:
            for args in split_list(result, 500):
                cmd = ['exim', '-Mf']
                cmd.extend(args)
                proc = Popen(cmd)
                proc.wait()
        else:
            for id in result:
                print id
        del result[:]


    result_found = False
    for header_file in walk_spool():
        tmp_dict = file_to_msgdict(header_file)
        filter_flags = [1, 1, 1] # user, address, host
        if user:
            for i in ['user', 'ident', 'auth_id']:
                if user.match(tmp_dict.get(i, ' ')):
                    break
            else:
                filter_flags[0] = 0

        if address:
            for i in ['address', 'auth_sender', 'from']:
                if address.match(tmp_dict.get(i, ' ')):
                    break
            else:
                filter_flags[1] = 0

        if host:
            for i in ['helo_name', 'host_address', 'host_name']:
                if host.match(tmp_dict.get(i, ' ')):
                    break
            else:
                filter_flags[2] = 0
        if sum(filter_flags) == 3:
            result_append(tmp_dict['mid'])
            result_found = True
            if len(result) >= 500:
                handle_results();

    if not result_found:
        print "No Messages Found"
    elif options.remove:
        for args in split_list(result, 500):
            cmd = ['exim', '-Mrm']
            cmd.extend(args)
            proc = Popen(cmd)
            proc.wait()
    elif options.freeze:
        for args in split_list(result, 500):
            cmd = ['exim', '-Mf']
            cmd.extend(args)
            proc = Popen(cmd)
            proc.wait()
    else:
        for id in result:
            print id

