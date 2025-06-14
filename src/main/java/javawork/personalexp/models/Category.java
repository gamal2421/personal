package javawork.personalexp.models;

import org.json.JSONObject;

public class Category {
    private int id;
    private String name;
    private int userId;

    // Constructor
    public Category(int id, String name, int userId) {
        this.id = id;
        this.name = name;
        this.userId = userId;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    // Method to convert Category object to JSON
    public JSONObject toJson() {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("id", this.id);
        jsonObject.put("name", this.name);
        return jsonObject;
    }
}
