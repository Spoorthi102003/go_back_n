# SYSTEM VERILOG IMPLEMENTATION OF GO-BACK-N:
Go-Back-N ARQ is a specific instance of the automatic repeat request (ARQ) protocol, in which the sending process continues to send a number of frames specified by a window size even without receiving an acknowledgment (ACK) packet from the receiver. 
GBN is a practical approach of sliding window protocol.

**Need of GBN**
* To send more than one frame at a time.
* To reduce the waiting time of the sender. 

**Sender sliding window**
* Sender can transmit N frames before receiving ACK.
* The window size is N ( N should be greater than 1). 
* Sender maintains a copy of the sent packets in the buffer until they are acknowledged.
* Once acknowledged, that particular data is removed from the buffer. 
* It resends all packets if the timer runs out. 

**Receiver sliding window**
* In this protocol, the size of the receiver window is always 1. 
* The receiver always looks for a specific frame to arrive in a specific order.
* Positive ACK is sent if a frame arrives safely and in order
* The sender then re-sends all frames beginning with the one with the expired timer. 

**Advantages of Go-Back-N**
* The sender can send many frames at a time.
* The timer can be set for a group of frames.
* Efficiency is more.
* Waiting time is pretty low.
* Receiver is simple.

# Reciever State Diagram And RTL
**State Diagram**
![image](https://github.com/Spoorthi102003/go_back_n/assets/143829280/cb2f909a-03ef-45a4-8a61-2155936c297b)

**RTL**
![Screenshot 2023-12-06 103749](https://github.com/Spoorthi102003/go_back_n/assets/143829280/d9e8d6b2-85aa-4943-a684-4273cfb6ad79)

# Reciver State Diagram And RTL
**State Diagram**
![image](https://github.com/Spoorthi102003/go_back_n/assets/143829280/cd2eea23-d308-4974-a950-ad53d13e8317)

**RTL**
![Screenshot 2023-12-06 102632](https://github.com/Spoorthi102003/go_back_n/assets/143829280/a8e31c84-8b81-4216-843b-6bf0465969b2)
![Screenshot 2023-12-06 102643](https://github.com/Spoorthi102003/go_back_n/assets/143829280/380fb102-7f34-41b0-afc5-127984561fbf)
![Screenshot 2023-12-06 102719](https://github.com/Spoorthi102003/go_back_n/assets/143829280/33e10c1f-0189-4406-b223-e0432abc2cfc)

