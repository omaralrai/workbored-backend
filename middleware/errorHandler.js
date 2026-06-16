// Best Practice: Centralized error handler — all unhandled route errors flow here.
// This keeps error logic out of individual route files (Separation of Concerns).
const errorHandler = (err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: "Something went wrong", error: err.message });
};

export default errorHandler;
