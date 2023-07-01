import os

with open('ips.txt', 'r') as f:
    ip = f.readline().strip()
    url = ip.split('@')[1]

wrk_path = "DeathStarBench/wrk2/wrk"
script_path = "DeathStarBench/socialNetwork/wrk2/scripts/social-network/compose-post.lua"
localhost_url = "http://localhost:8080/wrk2-api/post/compose"
internet_url = f"http://{url}:8080/wrk2-api/post/compose"

default_t = 2
default_c = 20
default_r = 100

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


def all_test():
    c = default_c
    t = default_t
    r = default_r

    for t in range(1, 11):
        os.system(f"ssh {ip} {wrk_path} -D exp -L -t {t} -c {c} -d 30s -s {script_path} {localhost_url} -R {r} > results/{get_filename(t, c, r)}")
        # os.system(f"./wrk -D exp -L -t {t} -c {c} -d 30s -s ~/{script_path} {internet_url} -R {r} > results_Internet/{get_filename(t, c, r)}")
        print('t', t)
    t = default_t

    for c in [10, 20, 50, 100, 1000]:
        os.system(f"ssh {ip} {wrk_path} -D exp -L -t {t} -c {c} -d 30s -s {script_path} {localhost_url} -R {r} > results/{get_filename(t, c, r)}")
        # os.system(f"./wrk -D exp -L -t {t} -c {c} -d 30s -s ~/{script_path} {internet_url} -R {r} > results_Internet/{get_filename(t, c, r)}")
        print('c', c)
    c = default_c

    for r in [10, 100, 300, 500, 1000, 2000]:
        os.system(f"ssh {ip} {wrk_path} -D exp -L -t {t} -c {c} -d 30s -s {script_path} {localhost_url} -R {r} > results/{get_filename(t, c, r)}")
        # os.system(f"./wrk -D exp -L -t {t} -c {c} -d 30s -s ~/{script_path} {internet_url} -R {r} > results_Internet/{get_filename(t, c, r)}")
        print('r', r)
    r = default_r

def default_test():
    c = default_c
    t = default_t
    r = default_r

    os.system(f"ssh {ip} {wrk_path} -D exp -L -t {t} -c {c} -d 30s -s {script_path} {localhost_url} -R {r} > replica_test/{get_filename(t, c, r)}")

if __name__ == "__main__":
    # all_test()
    default_test()