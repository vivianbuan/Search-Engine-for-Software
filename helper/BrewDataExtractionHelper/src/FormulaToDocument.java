import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class FormulaToDocument {

	public static void main(String[] args) {
		
		File currentDir;
		String line = null;
		int count = 0;
		
		try {
			// get data directory
			currentDir = new File("").getCanonicalFile();
			File parentDir = currentDir.getParentFile().getParentFile();
			File formulaDir = new File(parentDir, "data/homebrew_formula");
			
//			File outputFile = new File(formulaDir, "data/brew_formula.json");
//			outputFile.createNewFile();
//			FileWriter fileWriter = new FileWriter(outputFile);
//            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
            Writer bufferedWriter = new BufferedWriter(new OutputStreamWriter(
                    new FileOutputStream("brew_formula.json"), "utf-8"));
            JSONArray jsonArr = new JSONArray();
			
            for (File curFile: formulaDir.listFiles()) {
            	System.out.println(curFile.getName());
            	
    			// read data from doc
//    			File curFile = new File(formulaDir, "aircrack-ng.rb");
    			FileReader fr = new FileReader(curFile);
    			BufferedReader bufferedReader = new BufferedReader(fr);
    			JSONObject jsonObject = new JSONObject();
    			// start from second line, read until "bottle"
    			bufferedReader.readLine();
    			while((line = bufferedReader.readLine()) != null) {
    				line = line.trim();
    				if (line.startsWith("bottle") || line.startsWith("patch") 
    						|| line.startsWith("def") || line.endsWith("do") || line.startsWith("if")) break;
    				// process none-empty, non-comment line
    				if (line.isEmpty() || line.startsWith("#")) continue;
    				String[] tmp = line.split(" ", 2);
    				String value = tmp[1];
    				if (value.startsWith("\"")) value = value.substring(1);
    				if (value.endsWith("\"")) value = value.substring(0, value.length()-1);
    				jsonObject.put(tmp[0], value);
    			}
    			jsonArr.add(jsonObject);
    			
    			// close file
    			bufferedReader.close();
    			count++;
            }
            
			bufferedWriter.write(jsonArr.toJSONString());
			

            // close files. 
            bufferedWriter.close();
            
            System.out.println("Done! Total " + count + " files.");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
