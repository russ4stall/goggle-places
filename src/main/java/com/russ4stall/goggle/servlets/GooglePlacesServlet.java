package com.russ4stall.goggle.servlets;

import com.google.gson.Gson;
import com.google.maps.GeoApiContext;
import com.google.maps.NearbySearchRequest;
import com.google.maps.PlacesApi;
import com.google.maps.model.LatLng;
import com.google.maps.model.PlaceType;
import com.google.maps.model.PlacesSearchResponse;
import com.google.maps.model.PlacesSearchResult;
import com.google.maps.model.RankBy;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;

@WebServlet("/api/places")
public class GooglePlacesServlet extends HttpServlet {
    private final static int RADIUS_DISTANCE = 32186; // approximately 20 miles


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletContext context = getServletContext();
        GeoApiContext geoCtx = (GeoApiContext) context.getAttribute("GoogleApiGeoContext");

        String searchTerm = req.getParameter("searchTerm");
        String latitude = req.getParameter("latitude");
        String longitude = req.getParameter("longitude");
        String nextPageToken = req.getParameter("nextPageToken");
        String type = req.getParameter("type");

        PlacesSearchResponse placesResp = null;
        NearbySearchRequest nearbySearchReq = null;

        LatLng latLng = new LatLng(Double.parseDouble(latitude), Double.parseDouble(longitude));
        nearbySearchReq = PlacesApi.nearbySearchQuery(geoCtx, latLng).radius(RADIUS_DISTANCE);

        if (StringUtils.isNotEmpty(nextPageToken)) {
            nearbySearchReq = nearbySearchReq.pageToken(nextPageToken);
        }
        
        if (StringUtils.isNotEmpty(searchTerm)) {
            nearbySearchReq = nearbySearchReq.keyword(searchTerm);
        }

        if (StringUtils.isNotEmpty(type)) {
            nearbySearchReq = nearbySearchReq.type(PlaceType.valueOf(type.toUpperCase()));
        }

        try {
            placesResp = nearbySearchReq.await();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }

        json(req, resp, placesResp);
    }

    protected void json(HttpServletRequest req, HttpServletResponse resp, Object o) throws IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        Gson gson = new Gson();
        String result = gson.toJson(o);

        out.print(result);
        out.flush();
    }
}