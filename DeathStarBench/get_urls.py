with open('server_ips.txt', 'r') as f:
    ips = [f'"{line.strip()}"' for line in f.readlines()]

with open('client_ips.txt', 'r') as f:
    client_ips = [f'"{line.strip()}"' for line in f.readlines()]

with open('manager_ips.sh', 'w') as f:
    print(f'MANAGER_IPS={ips[0]}', file=f)

ips = ips[1:]

with open('worker_ips.sh', 'w') as f:
    print('WORKER_IPS=(\n\t' + '\n\t'.join(ips) + '\n)', file=f)

with open('client_ips.sh', 'w') as f:
    print('CLIENT_IPS=(\n\t' + '\n\t'.join(client_ips) + '\n)', file=f)