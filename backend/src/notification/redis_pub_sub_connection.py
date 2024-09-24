import datetime
import json

import redis.asyncio as redis
from config import settings
from notification.schemas import Event

class RedisPubSubManager:
    redis_connection = None

    def __init__(self, host=settings.REDIS_HOST, port=settings.REDIS_PORT):
        print(settings.REDIS_HOST)
        print(settings.REDIS_PORT)
        self.redis_host = host
        self.redis_port = port
        self.pubsub: redis.client.PubSub = None

    async def _get_redis_connection(self) -> redis.Redis:
        """
        Establishes a connection to Redis.

        Returns:
            redis.Redis: Redis connection object.
        """
        return redis.Redis(host=self.redis_host,
                           port=self.redis_port,
                           db=settings.REDIS_NOTIFY_DB,
                        #    username=settings.REDIS_USERNAME,
                        #    password=settings.REDIS_PASSWORD
        )

    async def connect(self) -> None:
        """
        Connects to the Redis server and initializes the pubsub client.
        """
        self.redis_connection = await self._get_redis_connection()
        self.pubsub = self.redis_connection.pubsub()

    async def publish(self, channel: str, event: Event) -> None:
        """
        Publishes a message to a specific Redis channel.

        Args:
            channel (str): Channel or room ID.
            event (str): Message to be published.
        """
        await self.redis_connection.publish(channel, json.dumps(event.model_dump(), default=self.json_serial).encode('utf-8'))

    async def subscribe(self, channel: str):
        """
        Subscribes to a Redis channel.

        Args:
            channel (str): Channel or room ID to subscribe to.

        Returns:
            redis.client.PubSub: PubSub object for the subscribed channel.
        """
        await self.pubsub.subscribe(channel)

    async def unsubscribe(self, room_id: str) -> None:
        """
        Unsubscribes from a Redis channel.

        Args:
            room_id (str): Channel or room ID to unsubscribe from.
        """
        await self.pubsub.unsubscribe(room_id)
    
    def json_serial(self, obj):
        """JSON serializer for objects not serializable by default json code"""
        if isinstance(obj, (datetime.datetime)):
            return obj.isoformat()
        raise TypeError ("Type %s not serializable" % type(obj))

    # @staticmethod
    # def get_pub_sub_conn() -> redis.client.PubSub:
    #     creds = get_redis_credentials(settings.REDIS_NOTIFY_DB)
    #     conn = RedisConnection(creds)
    #     return conn.pubsub()
    #
    # @staticmethod
    # def get_default_conn() -> redis.Redis:
    #     creds = get_redis_credentials(settings.REDIS_NOTIFY_DB)
    #     conn = RedisConnection(creds)
    #     return conn
