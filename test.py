import os

with open('client_ips.txt', 'r') as f:
    ip = f.readline().strip()

wrk_path = "DeathStarBench/wrk2/wrk"
script_path = "DeathStarBench/socialNetwork/wrk2/scripts/social-network/compose-post.lua"
lan_url = "http://node0:8080/wrk2-api/post/compose"

default_t = 16
default_c = 100
default_r = 1000

def get_filename(t, c, r):
    name = ""
    if t != default_t:
        name += f"t{t}-"
    if c != default_c:
        name += f"c{c}-"
    if r != default_r:
        name += f"r{r}-"

    if name == "":
        name = "default-"
    
    return f"{name}result.txt"

def create_if_not_exist(path):
    import os
    if not os.path.exists(path):
        os.makedirs(path)


def all_test():
    c = default_c
    t = default_t
    r = default_r

    print('start all test')

    create_if_not_exist('results')

    # for t in range(1, 11):
    #     os.system(f"ssh {ip} {wrk_path} -D exp -L -t {t} -c {c} -d 30s -s {script_path} {lan_url} -R {r} > results/{get_filename(t, c, r)}")
    #     # os.system(f"./wrk -D exp -L -t {t} -c {c} -d 30s -s ~/{script_path} {internet_url} -R {r} > results_Internet/{get_filename(t, c, r)}")
    #     print('t', t)
    # t = default_t

    # for c in range(100, 1001, 100):
    #     os.system(f"ssh {ip} {wrk_path} -D exp -L -t {t} -c {c} -d 30s -s {script_path} {lan_url} -R {r} > results/{get_filename(t, c, r)}")
    #     # os.system(f"./wrk -D exp -L -t {t} -c {c} -d 30s -s ~/{script_path} {internet_url} -R {r} > results_Internet/{get_filename(t, c, r)}")
    #     print('c', c)
    # c = default_c

    for c in range(100, 1001, 100):
        print('c', c)
        for r in [10, 100, 300, 500, 1000, 2000]:
            os.system(f"ssh {ip} {wrk_path} -D exp -L -t {t} -c {c} -d 30s -s {script_path} {lan_url} -R {r} > results/{get_filename(t, c, r)}")
            # os.system(f"./wrk -D exp -L -t {t} -c {c} -d 30s -s ~/{script_path} {internet_url} -R {r} > results_Internet/{get_filename(t, c, r)}")
            print('r', r)
    r = default_r

def default_test():
    c = default_c
    t = default_t
    r = default_r + 500

    # os.system(f"ssh {ip} {wrk_path} -D exp -L -t {t} -c {c} -d 30s -s {script_path} {lan_url} -R {r} > replica_test/{get_filename(t, c, r)}")
    os.system(f"ssh {ip} {wrk_path} -D exp -L -t {t} -c {c} -d 30s -s {script_path} {lan_url} -R {r} > replica_test/_nginx-result.txt")

if __name__ == "__main__":
    # all_test()
    default_test()