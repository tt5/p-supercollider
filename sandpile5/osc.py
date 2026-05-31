import time
import math

import numpy as np
from pythonosc import udp_client
from pythonosc.dispatcher import Dispatcher
from datetime import datetime
import random

dispatcher = Dispatcher()

# **kwargs collects any arguments we forgot to set explicitly 
def print_osc(address, message, **kwargs):
    print("{time} - {message}".format(
        time=datetime.now().strftime("%H:%M:%S.%f"),
        message=message,
    ))

osc_client = udp_client.SimpleUDPClient(address='127.0.0.1', port=57120)

#from pythonosc.osc_server import ThreadingOSCUDPServer
#
#server = ThreadingOSCUDPServer(
#    # sclang is listening on port 57320 so we take 57310 for python
#    server_address=("127.0.0.1", 57310),
#    dispatcher=dispatcher
#)
#print(f"Start OSC server on port {server.server_address[-1]}")
#
#try:
#    server.serve_forever()
#except KeyboardInterrupt:
#    print(f"Shutdown Python server on port {server.server_address[-1]}")
#finally:
#    server.server_close()

def A014675(n): return (n+2+math.isqrt(m:=5*(n+2)**2)>>1)-(n+1+math.isqrt(m-10*n-15)>>1)
def A006337(n): return -math.isqrt(m:=n*n<<1)+math.isqrt(m+(n<<2)+2)
# 0,1
def A080764(n): return (math.isqrt((m:=(n+2)**2)<<1)>>1)-(math.isqrt(m-(n<<1)-3<<1)>>1)
def A171588(n): return 1+math.isqrt(n**2>>1)-math.isqrt((n+1)**2>>1)

def gen_sturm_eta():
    var = 0
    while True:
          if (A006337(var) == 2) and (var%1 == 0):
              val = 1
          else:
              val = 0
          yield (val)
          var +=1
getgen_sturm_eta = gen_sturm_eta()

def gen_sturm_2():
    var = 0
    while True:
          if ((A080764(var) + A080764(var+1)) == 2) and (var%1 == 0):
              val = 1
          else:
              val = 0
          yield (val)
          var +=2
getgen_sturm_2 = gen_sturm_2()

def gen_sturm_3():
    var = 0
    while True:
          if ((A171588(var) + A171588(var+1) +1) == 2) and (var%1 == 0):
              val = 1
          else:
              val = 0
          yield (val)
          var +=2
getgen_sturm_3 = gen_sturm_3()

def gen():
      var = 0
      while True:
          if (A014675(var) == 2) and (var%1 == 0):
              val = 1
          else:
              val = 0
          yield (val)
          var +=1
getgen = gen()


keyTwo = 48
for i in range(1000):
    key = 38 - next(getgen_sturm_2)*2
    #key = 40

    #key = 48 - next(getgen_sturm_2)*6
    
    val2 = 4*next(getgen_sturm_3)
    val3 = 3*next(getgen)

    key1 = key + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    key2 = key + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    key3 = key + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    key4 = key + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    key5 = key + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    key6 = key + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    key7 = key + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    key8 = key + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3

    #rand = random.randint(0,1)
    #rand = next(getgen_sturm_2)
    rand = 1
    #key1 = key1 * -(next(getgen_sturm_2)-1) * rand
    #key2 = key2 * -(next(getgen_sturm_2)-1) * rand
    #key3 = key3 * -(next(getgen_sturm_2)-1) * rand
    #key4 = key4 * -(next(getgen_sturm_2)-1) * rand
    #key5 = key5 * -(next(getgen_sturm_2)-1) * rand
    #key6 = key6 * -(next(getgen_sturm_2)-1) * rand
    #key7 = key7 * -(next(getgen_sturm_2)-1) * rand
    #key8 = key8 * -(next(getgen_sturm_2)-1) * rand

    key1 = key1 * -(next(getgen_sturm_2)-1) * rand
    key2 = key2 * -(next(getgen_sturm_2)-1) * rand
    key3 = key3 * -(next(getgen_sturm_2)-1) * rand
    key4 = key4 * -(next(getgen_sturm_2)-1) * rand
    key5 = key5 * -(next(getgen_sturm_2)-1) * rand
    key6 = key6 * -(next(getgen_sturm_2)-1) * rand
    key7 = key7 * -(next(getgen_sturm_2)-1) * rand
    key8 = key8 * -(next(getgen_sturm_2)-1) * rand

    test =  [34,34,34,34, 60,60,60,60]


    rhy1=[]
    #rhya = [2,0,2,0, 2,0,2,0]
    rhy = [
        [2,0,2,0,2,0,2,0],
        [1,0,0,0,1,0,0,0],
    ]
    rhy1 = rhy[next(getgen_sturm_2)]

    osc_client.send_message("/key1", [key1,key2,key3,key4,key5,key6,key7,key8])
    osc_client.send_message("/key2", [key7+4,key8+4,key1+4,key2+4,key3+4,key4+4,key5+4,key6+4])
    osc_client.send_message("/key3", [key5+7,key6+7,key7+7,key8+7,key1+7,key2+7,key3+7,key4+7])
    #osc_client.send_message("/key1", test)
    #osc_client.send_message("/key2", silence)
    #osc_client.send_message("/key2", silence)
    osc_client.send_message("/rhy1", rhy1)
    print("---")
    #print(next(getgen_sturm_eta))
    #print(next(getgen_sturm_2))
    #print(next(getgen_sturm_3))
    #print(next(getgen))
    print(key)
    time.sleep(105/120)
