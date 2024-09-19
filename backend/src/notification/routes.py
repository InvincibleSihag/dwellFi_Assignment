
from datetime import time
from fastapi import APIRouter, Depends, WebSocket, WebSocketDisconnect

from notification.publishing_handler import EventPublisher
from notification.subscription_handler import EventSubscription


events_routes = APIRouter(
    prefix="/notification",
    tags=['Notification']
)

eventSubs: EventSubscription = EventSubscription()
eventPubs: EventPublisher = EventPublisher()


@events_routes.websocket("/v2/events")
async def websocket_endpoint(websocket: WebSocket,
                             user_id: str):

    await eventSubs.subscribe_socket_to_channel(websocket, "notify:userid:"+user_id)
    try:
        while True:
            data = await websocket.receive_text()
            print("Received data from socket = " + str(data))
            time.sleep(1)
            # We don't have to do anything with the data

    except WebSocketDisconnect:
        print("disconnected")
        await eventSubs.unsubscribe_socket_from_channel(websocket, "notify:userid:"+user_id)
