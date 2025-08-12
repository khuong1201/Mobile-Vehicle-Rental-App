const swaggerJSDoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.1',
    info: {
      title: 'Vehicle Rental API',
      version: '1.0.0',
      description: 'API documentation for the vehicle rental system'
    },
    servers: [
      { url: 'http://localhost:5000', description: 'Local server' }
    ],
    components: {
      securitySchemes: {
        BearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        }
      }
    },
    security: [{ BearerAuth: [] }]
  },
  apis: ['./routes/*.js'] 
};

module.exports = swaggerJSDoc(options);
