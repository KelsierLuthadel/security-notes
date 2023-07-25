# Sequence and Acknowledgement 

Every frame that is sent to it's intended recipient has to be acknowledged by the recipient, this ensures successful delivery. The way that this is done in TCP is by using the `Sequence` and `Acknowledgement` fields in the [TCP Header](tcp.md).

The sender of the frame adds the current sequence number to the length of the data (`Segment length`), and stores this value. 

When the recipient receives the frame, it also adds the sender's sequence number to the length of the data it receives and uses that value to acknowledge the frame.


**Example**
| Id |Source  | Destination | Seq    |  Ack  | Length |
|---:|--------|-------------|-------:|------:|-------:|
|  1 | Client | Server      |  `1`   | 1     | `178`  |
|  2 | Server | Client      |  1     | `179` | 512    |
|  3 | Client | Server      |  `179` | 513   | 166    |

Client (Id 1):

- Send a frame containing `178` bytes worth of data to the server
- The sequence number is `1`
- The client will expect an acknowledgement of `179` (seq + segment length)

Server (Id 2):

- Receives a frame containing `178` bytes worth of data
- Acknowledges the frame with a value of `179`

Client (Id 3):

- Uses the Acknowledgement value `179` from the server as it's sequence number


**Example**
| Id |Source  | Destination | Seq    |  Ack  | Length |
|---:|--------|-------------|-------:|------:|-------:|
|  3 | Client | Server      |  `179` | 513   | `166`  |
|  4 | Server | Client      |  513   | `345` | 347    |
|  5 | Client | Server      |  `345` | 860   | 643    |

Client (Id 1):

- Send a frame containing `166` bytes worth of data to the server
- The sequence number is `179` 
- The client will expect an acknowledgement of `345` (seq + segment length)

Server (Id 2):

- Receives a frame containing `166` bytes worth of data
- Acknowledges the frame with a value of `345`

Client (Id 3):

- Uses the Acknowledgement value `345` from the server as it's sequence number

## Large packets
When a client is sending data that is too large to fit into a single packet, it will send multiple frames.

**Example**
| Id |Source  | Destination | Seq     | Ack    | Length |
|---:|--------|-------------|--------:|-------:|-------:|
| 9  | Client | Server      |  `1096` | 1049   | `124`  |
| 10 | Client | Server      |  `1220` | 1049   | `236`  |
| 11 | Server | Client      |  1049   | `1456` | 0      |

Client (Id 9):

- Send a frame containing `124` bytes worth of data to the server
- The sequence number is `1096` 
- Send a second frame containing `236` bytes worth of data to the server
    - The client will use the sequence number of `1220` (seq + segment length of previous frame)
    - The Ack will remain the same
- The client will expect an acknowledgement of `1456` (seq + segment length)

Server (Id 10):

- Receives two frames containing 360 bytes worth of data
- Acknowledges the frame with a value of `1456`

