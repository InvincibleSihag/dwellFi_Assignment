from notification.schemas import Event
from notification.redis_pub_sub_connection import RedisPubSubManager


class EventPublisher:
    _instance = None
    """
        This class handles the publishing of events to the redis channels
    """
    pubsub_client = RedisPubSubManager()

    def __int__(self):
        self.pubsub_client = RedisPubSubManager()

    async def publish_to_channel(self, channel, event: Event):
        if self.pubsub_client.redis_connection is not None:
            try:
                await self.pubsub_client.redis_connection.ping()
            except Exception as e:
                print("health check = ")
                print(e)
                await self.pubsub_client.connect()
        else:
            await self.pubsub_client.connect()
        print("Publishing " + str(event) + " to channel -> " + channel)
        # await self.pubsub.connect()
        await self.pubsub_client.publish(channel, event)

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
