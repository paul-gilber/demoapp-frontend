const DEMOAPP_BACKEND_URL = (typeof window.env === 'undefined') ? process.env.REACT_APP_DEMOAPP_BACKEND_URL : window.env.REACT_APP_DEMOAPP_BACKEND_URL;

exports.DEMOAPP_BACKEND_URL = DEMOAPP_BACKEND_URL
