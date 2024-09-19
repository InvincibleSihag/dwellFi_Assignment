from exception import AppException


class FileNotFoundException(AppException):
    """Exception raised when a file is not found."""
    def __init__(self, file_id: int):
        self.file_id = file_id
        self.message = f"File with id {self.file_id} not found."
        super().__init__(self.message)

class FileProcessingException(AppException):
    """Exception raised when there is an error processing a file."""
    def __init__(self, file_id: int, reason: str):
        self.file_id = file_id
        self.reason = reason
        self.message = f"Error processing file with id {self.file_id}: {self.reason}"
        super().__init__(self.message)

class InvalidFileTypeException(AppException):
    """Exception raised when the file type is invalid."""
    def __init__(self, file_type: str):
        self.file_type = file_type
        self.message = f"Invalid file type: {self.file_type}"
        super().__init__(self.message)
