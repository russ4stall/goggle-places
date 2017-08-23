package com.russ4stall.goggle.models;

public class Business {
    private String placeId;
    private String name;
    private String notes;
    

    public Business(String placeId, String name, String notes) {
        this.placeId = placeId;
        this.name = name;
        this.notes = notes;
    }

    public Business() {        
    }

    public String getPlaceId() {
        return this.placeId;
    }

    public void setPlaceId(String placeId) {
        this.placeId = placeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}