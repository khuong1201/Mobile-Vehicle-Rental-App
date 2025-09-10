export const errorHandler = (err, req, res, next) => {
    console.error(err); 

    const statusCode = err.statusCode || 500;
    const message = err.message || 'Internal Server Error';

    const details = err.details || null;

    res.status(statusCode).json({
        status: 'error',
        message,
        ...(details && { details }),
        stack: process.env.NODE_ENV === 'development' ? err.stack : undefined
    });
};
