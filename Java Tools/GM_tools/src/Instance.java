@SuppressWarnings("unused")
public class Instance {
    private String instance_name;
    private String object_type;
    private String category;
    private Vector2 position;
    private Vector2 scale;
    private double rotation;

    public Instance(String instance_name, String object_type, String category, Vector2 position, Vector2 scale, double rotation) {
        this.instance_name = instance_name;
        this.object_type = object_type;
        this.category = category;
        this.position = position;
        this.scale = scale;
        this.rotation = rotation;
    }

    @Override
    public String toString() {
        return String.format("""
                   InstanceName : %s
                   ObjectType   : %s
                   Position     : %f | %f
                   Scale        : %f | %f
                   Rotation     : %f
                """,
                    instance_name, object_type, position.x, position.y,
                    scale.x, scale.y, rotation
                );
    }

    public void setInstance_name(String instance_name) {
        this.instance_name = instance_name;
    }

    public String getInstance_name() {
        return instance_name;
    }

    public void setObject_type(String object_type) {
        this.object_type = object_type;
    }

    public String getCategory() {
        return category;
    }

    public void setPosition(Vector2 position) {
        this.position = position;
    }

    public void setScale(Vector2 scale) {
        this.scale = scale;
    }

    public void setRotation(double rotation) {
        this.rotation = rotation;
    }

    public String getObject_type() {
        return object_type;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Vector2 getPosition() {
        return position;
    }

    public Vector2 getScale() {
        return scale;
    }

    public double getRotation() {
        return rotation;
    }
}
