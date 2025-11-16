package model;

public class Service {
    private int id;
    private String name;
    private float price; // attribute in UML diagram
    private String description;

    public Service() {}

    public Service(String name, float price, String description) {
        this.name = name;
        this.price = price;
        this.description = description;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public float getPrice() { return price; }
    public void setPrice(float price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}

