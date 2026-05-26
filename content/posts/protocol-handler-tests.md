+++
title = 'Protocol Handler Tests: Transport-Independent by Design'
date = 2026-05-26
authors = ['Sungsik']
categories = ['C++']
tags = ['GMock', 'Testability', 'Network']
featuredImage = 'images/protocol-handler-transport-independent.png'
+++

# 

Suppose we are implementing a very small line-oriented protocol. Each message is terminated by `\r\n`, and the session ends when the client sends `Bye\r\n`.

The behavior is simple:

- client sends `Hello?\r\n`
- server replies with `Hi!\r\n`
- client sends `Bye\r\n`
- server replies with `Bye!\r\n` and closes the session

A common temptation is to write the handler directly against a socket, stream, or some other concrete transport object.
That works, but it makes the protocol handler hard to test: every test needs a socket-like implementation, buffering logic, possibly a thread, and maybe even a timeout.

Instead, I want the protocol handler to know only about a small `Connection` abstraction.

```cpp
template <ConnectionType Conn>
void run_client(Conn& conn) {
    while (true) {
        auto line = conn.peek_line();

        if (line == "Hello?") {
            conn.write("Hi!\r\n"sv);
            conn.consume();
        } else if (line == "Bye") {
            conn.write("Bye!\r\n"sv);
            conn.consume();
            break;
        }
    }
}
```

The important point here is that `run_client` does not depend on TCP, TLS, files, pipes, or any particular transport mechanism. It depends only on the operations required by the protocol:

- `peek_line()` reads the next complete line without copying it
- `consume()` advances the input buffer after the current line has been handled
- `write(...)` sends a response

In other words, the transport layer is hidden behind a `Connection` type. By injecting that type into the handler, the handler becomes transport-independent.

That gives us a useful design property: we can test the protocol logic without implementing any transport layer at all.

## Testing the Handler

With GoogleMock, the test can describe the conversation directly:

```cpp
TEST(AClient, HandlesHelloAndBye) {
    testing::NiceMock<MockConnection> mock_conn;

    EXPECT_CALL(mock_conn, peek_line())
        .WillOnce(testing::Return("Hello?"))
        .WillOnce(testing::Return("Bye"));

    {
        testing::InSequence seq;
        EXPECT_CALL(mock_conn, write("Hi!\r\n"));
        EXPECT_CALL(mock_conn, consume());
        EXPECT_CALL(mock_conn, write("Bye!\r\n"));
        EXPECT_CALL(mock_conn, consume());
    }

    run_client(mock_conn);
}
```

`EXPECT_CALL` defines the interaction between the handler and the injected connection.
The first expectation says that `peek_line()` will be called twice.
It returns `"Hello?"` first, then `"Bye"`.
That simulates the request data received by the server.

The second group of expectations verifies the output side.
The handler must write `"Hi!\r\n"`, consume the input line, then write `"Bye!\r\n"`, consume again, and finish the loop.
`testing::InSequence` enforces the order of the following expectations.

Since `run_client` contains a loop, it is still a good idea to set a timeout for the test:

```cmake
set_tests_properties(client_test PROPERTIES TIMEOUT 5)
```

If the handler fails to break out of the loop, the test fails quickly instead of hanging forever.

## The Mock Connection

The mock connection can be almost entirely declarative:

```cpp
class MockConnection {
public:
    MOCK_METHOD(std::string_view, peek_line, (), ());
    MOCK_METHOD(void, consume, (), ());
    MOCK_METHOD(void, write, (std::string_view data), ());
};
```

This is the second benefit of the design: GoogleMock gives us a zero-implementation fake.
The mock only declares the interface that the handler needs, and each test describes the behavior relevant to that specific scenario.

A real production connection may internally use TCP, TLS, or any other transport.
The handler does not care.
As long as the type satisfies `ConnectionType`, it can be passed to `run_client`.
