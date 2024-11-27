import java.io.File;

public class RoomCreator {

    public RoomCreator()
    {
        // TODO: Create a new Room.yy file and put it inside the
        //      rooms folder in GameMaker, needs:
        //          * A folder with the same name of the Room (TextFile)
        //          * A .yy file inside the folder with also the same name
    }

    public static void main(String[] args) {
        String sfile = args[0]; // Absolute file path please
        File file = new File(sfile);
        System.out.println(file.getAbsolutePath());
    }
}