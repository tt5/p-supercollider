import time
import math

import numpy as np
from pythonosc import udp_client
from pythonosc.dispatcher import Dispatcher
from datetime import datetime

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


key = 48
for i in range(240):
    
    val2 = 4*next(getgen_sturm_3)
    val3 = 3*next(getgen)
    key1 = 48 + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    key2 = 48 + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    key3 = 48 + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    key4 = 48 + next(getgen_sturm_eta) - next(getgen_sturm_2) + val2 + val3
    osc_client.send_message("/key1", [key1,key1,key2,key2,key3,key3,key4,key4])
    print("---")
    #print(next(getgen_sturm_eta))
    #print(next(getgen_sturm_2))
    #print(next(getgen_sturm_3))
    #print(next(getgen))
    print(key)
    time.sleep(10)
