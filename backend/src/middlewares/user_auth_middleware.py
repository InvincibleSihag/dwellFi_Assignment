
from fastapi import Request, Response
from starlette.middleware.base import BaseHTTPMiddleware
from starlette import status

class UserAuthentication(BaseHTTPMiddleware):
    def __init__(self, app):
        super().__init__(app)

    async def dispatch(self, request: Request, call_next):
        # print(await request.body())
        try:
            request.state.user_id = "qwertyuiop"
        except Exception as e:
            print(str(e))
            return Response(
                status_code=status.HTTP_401_UNAUTHORIZED,
                content="Not Authorized"
            )
        response = await call_next(request)
        return response
