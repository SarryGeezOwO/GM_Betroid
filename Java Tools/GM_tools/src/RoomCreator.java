import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Random;

public class RoomCreator {

// Instances layer will be based on category
/* Layers get created as this same order

    /Gme          <- GameObjects,           such as Room transitions, and player starter position
    /Enm          <- Enemies
    /Haz          <- Hazard object,         such as spikes
    /Prp          <- Props,                 such as grass
    /Env          <- Environment Object     such as Ground
*/

    private final ArrayList<String> lines = new ArrayList<>();
    private final String[] categories = {"Environment", "Props", "Hazard", "Enemies", "Game objects"};
    private final String[] categories_ac = {"/Env", "/Prp", "/Haz", "/Enm", "/Gme"};
    private final ArrayList<Instance> instances = new ArrayList<>();
    private final String roomName;

    private final int roomCount;
    private final Vector2 roomDimension;
    private final List<String> templateFile;
    private final List<String> projectFile;
    private final List<String> project_resFile;

    private final Path projPath;
    private final Path proj_resPath;

    private final File outputDir;
    private final File outputFile;

    public RoomCreator(File file, String gm_dir) throws IOException {
        String projectName = gm_dir.substring(gm_dir.lastIndexOf("\\") + 1);
        File roomDir = new File(gm_dir + "/rooms");
        roomCount = Objects.requireNonNull(roomDir.listFiles()).length;

        roomName = file.getName().substring(0, file.getName().length()-4);
        outputDir = new File(gm_dir + "/rooms/" + roomName);
        outputFile = new File(outputDir.getAbsolutePath() + "/" + roomName + ".yy");

        Path tempPath = Paths.get(gm_dir + "/" + "rooms/rTemplateRoom/rTemplateRoom.yy");
        templateFile = Files.readAllLines(tempPath);

        projPath = Paths.get(gm_dir + "/" + projectName + ".yyp");
        projectFile = Files.readAllLines(projPath);

        proj_resPath = Paths.get(gm_dir + "/" + projectName + ".resource_order");
        project_resFile = Files.readAllLines(proj_resPath);

        try ( BufferedReader reader = new BufferedReader(new FileReader(file)) )
        {
            String line;
            while((line = reader.readLine()) != null) {
                if (!line.isEmpty()) {
                    lines.add(line);
                }
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        // Get room size
        roomDimension = new Vector2();
        roomDimension.x = toReal(lines.get(0)); // Width
        roomDimension.y = toReal(lines.get(1)); // Height
        generate_instances();
    }

    public void generate_GM_file() throws IOException {
        if (outputDir.mkdir()) {
            System.out.println("Folder created ["+roomName+"]");
        }

        if (outputFile.createNewFile()) {
            System.out.println("Room file created ["+roomName+".yy]");
            System.out.println("Updating Game maker resource order");
            insertToFile(
                    projectFile,
                    "{\"id\":{\"name\":\""+roomName+"\",\"path\":\"rooms/"+roomName+"/"+roomName+".yy\",},},",
                    "\"resources\":[");

            insertToFile(
                    project_resFile,
                    "{\"name\":\""+roomName+"\",\"order\":"+(roomCount+1)+",\"path\":\"rooms/"+roomName+"/"+roomName+".yy\",},",
                    "\"ResourceOrderSettings\":[");
        }

        // copy contents of temporary file to the newly created File with some modifications
        BufferedWriter writer = modifyRoomFile();
        writer.close();

        // Add instances to the new room
        Path roomPath = Path.of(outputFile.toURI());
        List<String> roomFile = Files.readAllLines(roomPath);
        for (Instance inst : instances)
        {
            // Creation order=
            insertToFile(
                    roomFile,
                    "{\"name\":\""+inst.getInstance_name()+"\",\"path\":\"rooms/"+roomName+"/"+roomName+".yy\",},",
                    "\"instanceCreationOrder\":["
                    );
        }

        for (String cat : categories) {

            insertToFile(
                    roomFile,
                    "],\"layers\":[],\"name\":\""+cat+"\",\"properties\":[],\"resourceType\":\"GMRInstanceLayer\",\"resourceVersion\":\"2.0\",\"userdefinedDepth\":false,\"visible\":true,},",
                    "\"layers\":["
                    );
            for (Instance inst : instances) {
                if (validateCategory(inst.getCategory(), cat)) {
                    System.out.println("Inserted instance ["+inst.getObject_type()+"] to layer: ["+cat+"]");
                    insertToFile(
                            roomFile,
                                "{\"$GMRInstance\":\"v1\",\"%Name\":\""+inst.getInstance_name()+"\",\"colour\":4294967295,\"frozen\":false,\"hasCreationCode\":false," +
                                "\"ignore\":false,\"imageIndex\":0,\"imageSpeed\":1.0,\"inheritCode\":false,\"inheritedItemId\":null,\"inheritItemSettings\":false,\"isDnd\":false," +
                                "\"name\":\""+inst.getInstance_name()+"\",\"objectId\":{\"name\":\""+inst.getObject_type()+"\",\"path\":\"objects/"+inst.getObject_type()+"/"+inst.getObject_type()+".yy\",},\"properties\":[],\"resourceType\":\"GMRInstance\"," +
                                "\"resourceVersion\":\"2.0\",\"rotation\":"+inst.getRotation()+",\"scaleX\":"+inst.getScale().x+",\"scaleY\":"+inst.getScale().y+",\"x\":"+inst.getPosition().x+",\"y\":"+inst.getPosition().y+",},",
                            "\"layers\":["
                    );
                }
            }
            // Add the layer
            insertToFile(
                    roomFile,
                    "{\"$GMRInstanceLayer\":\"\",\"%Name\":\""+cat+"\",\"depth\":0,\"effectEnabled\":true,\"effectType\":null,\"gridX\":32,\"gridY\":32,\"hierarchyFrozen\":false,\"inheritLayerDepth\":false,\"inheritLayerSettings\":false,\"inheritSubLayers\":true,\"inheritVisibility\":true,\"instances\":[",
                    "\"layers\":["
                    );
        }


        // Apply new modifications to the file
        Files.write(projPath, projectFile);
        Files.write(proj_resPath, project_resFile);
        Files.write(roomPath, roomFile);
    }

    private BufferedWriter modifyRoomFile() throws IOException {
        BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));
        for (String s : templateFile) {
            String l = s.replaceAll("rTemplateRoom", roomName);
            if (l.contains("\"Height\":")) {
                int index = l.indexOf(":")+1;
                l = l.substring(0, index) + roomDimension.y + ",";
            }
            else if (l.contains("\"Width\":")) {
                int index = l.indexOf(":")+1;
                l = l.substring(0, index) + roomDimension.x + ",";
            }

            writer.write(l + "\n");
        }
        return writer;
    }

    private void insertToFile(List<String> _lines, String newStr, String marker) {
        int index = -1;

        int counter = 0;
        for(String str : _lines) {
            if (str.trim().equals(marker)) {
                index = counter+1;
                break;
            }
            counter++;
        }

        if (index != -1) {
            _lines.add(index, newStr);
        }
    }

    private boolean validateCategory(String acronym, String category_index)
    {
        int hitI = -1;
        for(int i = 0; i < categories.length; i++)
        {
            if (categories[i].equals(category_index)) {
                hitI = i;
                break;
            }
        }

        int hitIac = -1;
        for(int i = 0; i < categories_ac.length; i++)
        {
            if (categories_ac[i].equals(acronym)) {
                hitIac = i;
                break;
            }
        }

        return  hitI == hitIac;
    }

    private void generate_instances() {
        for (int i = 2; i < lines.size(); i+=7) {
            Instance ins = generate_instance_data(i);
            instances.add(ins);
        }
    }

    private Instance generate_instance_data(int line) {
        Random random = new Random();
        String modifier = String.valueOf(random.nextInt(1, 9999));

        return new Instance(
            (lines.get(line) + "_" +modifier),
            lines.get(line), lines.get(++line),
            new Vector2(toReal(lines.get(++line)), toReal(lines.get(++line))),
            new Vector2(toReal(lines.get(++line)), toReal(lines.get(++line))),
            toReal(lines.get(++line))
        );
    }

    private double toReal(String str) {
        try {
            return Double.parseDouble(str);
        }
        catch (NumberFormatException lol)
        {
            return -1.0; // error code
        }
    }

    public static void main(String[] args) throws IOException {
        String sfile = args[0]; // Absolute file path please
        String gmDir = args[1]; // Path to the Game Maker project folder
        File file = new File(sfile);

        RoomCreator rc = new RoomCreator(file, gmDir);
        rc.generate_GM_file();
    }
}