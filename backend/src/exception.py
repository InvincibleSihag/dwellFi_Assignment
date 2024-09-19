class AppException(Exception):
    """Base class for all application-specific exceptions."""
    def __init__(self, message: str):
        self.message = message
        super().__init__(self.message)

class UserNotFoundException(AppException):
    """Exception raised when a user is not found."""
    def __init__(self, user_id: str):
        self.user_id = user_id
        self.message = f"User with id {self.user_id} not found."
        super().__init__(self.message)
