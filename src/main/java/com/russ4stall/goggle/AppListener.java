package com.russ4stall.goggle;

import com.google.maps.GeoApiContext;

import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        GeoApiContext geoCtx = new GeoApiContext.Builder()
            .apiKey("AIzaSyA2xB8lu0Vyn_AT-xEobYTxKKFc8hI27Pc")
            .build();

        event.getServletContext().setAttribute("GoogleApiGeoContext", geoCtx);
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        
    }

}