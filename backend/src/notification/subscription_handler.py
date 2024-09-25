import asyncio
from starlette.websockets import WebSocket

from notification.redis_pub_sub_connection import RedisPubSubManager


class EventSubscription:
    """
        This class handles the subscription of websockets with the redis channels
    """
    _instance = None
    user_sockets = {}
    channel_tasks = {}
    pubsub_client: RedisPubSubManager = RedisPubSubManager()
    # connection = pubsub_client.connect()
    listening_task: asyncio.Task = None

    def __int__(self):
        self.pubsub_client: RedisPubSubManager = RedisPubSubManager()
        # self.connection = self.pubsub_client.connect()
        # It is hashmap of String<user_id>, List[SocketConnections]
        self.user_sockets = {}

    async def _listen(self):
        print(self.pubsub_client.pubsub)
        while True:
            try:
                while True:
                    message = await self.pubsub_client.pubsub.get_message(ignore_subscribe_messages=True)
                    if message is not None and message['channel'] is not None:
                        channel_id = message['channel'].decode('utf-8')
                        all_sockets = self.user_sockets[channel_id]
                        for socket in all_sockets:
                            data = message['data'].decode('utf-8')
                            await socket.send_text(data)
            except Exception as e:
                print("Exception while listening for channels " + str(self.pubsub_client.pubsub.channels.items()))
                print(str(e))
                self.pubsub_client = RedisPubSubManager()
                await self.pubsub_client.connect()
                await self.ensure_connection_and_subscribe()
                

    def re_establish_listening(self, r):
        print("Creating new listening task")
        self.listening_task = asyncio.create_task(self._listen())
        self.listening_task.add_done_callback(self.re_establish_listening)

    async def subscribe_socket_to_channel(self, socket: WebSocket, channel: str):
        if not channel or channel == "":
            print("Channel is None")
            return
        await socket.accept()
        if channel in self.user_sockets:
            self.user_sockets[channel].append(socket)
        else:
            self.user_sockets[channel] = [socket]
            await self.ensure_connection_and_subscribe(channel)
            if self.listening_task is None:
                self.re_establish_listening(None)
                # self.listening_task = asyncio.create_task(self._listen(self.pubsub_client.pubsub))
            print(channel + " subscribed")

    async def unsubscribe_socket_from_channel(self, socket: WebSocket, channel):
        self.user_sockets[channel].remove(socket)
        if len(self.user_sockets[channel]) == 0:
            del self.user_sockets[channel]
            await self.pubsub_client.unsubscribe(channel)

    async def ensure_connection_and_subscribe(self, channel=None):
        if self.pubsub_client.pubsub is not None:
            try:
                await self.pubsub_client.pubsub.ping()
            except Exception as e:
                print("health check = ")
                print(e)
                await self.pubsub_client.connect()
        else:
            await self.pubsub_client.connect()
        if channel is None:
            print("Subscribing all channels again")
            print(self.user_sockets.keys())
            if len(self.user_sockets.keys()) > 0:
                await self.pubsub_client.subscribe(*self.user_sockets.keys())
        else:
            await self.pubsub_client.subscribe(channel)

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
