
"""Small example OSC server anbd client combined
This program listens to serveral addresses and print if there is an input.
It also transmits on a different port at the same time random values to different addresses.
This can be used to demonstrate concurrent send and recieve over OSC
"""

import random
import time
import threading

from pythonosc import udp_client
from pythonosc.dispatcher import Dispatcher
from pythonosc import osc_server


def handlesc(unused_addr, args, value):
    print(f"[{args[0]}] ~ {value:0.2f}")


# listen to addresses and print changes in values
dispatcher = Dispatcher()
dispatcher.map("/sc", handlesc, "sc")

serverip = "127.0.0.1"
serverport = 57121
clientip = "127.0.0.1"
clientport = 57120


def start_server(ip, port):
    print("Starting Server")
    server = osc_server.ThreadingOSCUDPServer((serverip, serverport), dispatcher)
    print(f"Serving on {server.server_address}")
    thread = threading.Thread(target=server.serve_forever)
    thread.start()


def start_client(ip, port):
    print("Starting Client")
    client = udp_client.SimpleUDPClient(ip, port)
    # print("Sending on {}".format(client.))
    thread = threading.Thread(target=random_values(client))
    thread.start()


# send random values between 0-1 to the three addresses
def random_values(client):
    while True:
        for x in range(10):
            client.send_message("/sc", random.random())
            time.sleep(0.5)


start_server(serverip, serverport)
start_client(clientip, clientport)
