import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.HashSet;
import java.util.Set;

import org.json.simple.JSONObject;

/*
 * Extract content from homebrew formula (https://github.com/Homebrew/homebrew-core/tree/master/Formula)
 * into json files.
 * */
public class FormulaToDocument {

	public static void main(String[] args) {
		
		File currentDir;
		String line = null;
		int count = 0;
		
		Set<String> keys = new HashSet<>();
		keys.add("name");
		
		try {
			// get data directory
			currentDir = new File("").getCanonicalFile();
			File parentDir = currentDir.getParentFile().getParentFile();
			File formulaDir = new File(parentDir, "data/homebrew_formula");
			
//			File outputFile = new File(formulaDir, "data/brew_formula.json");
//			outputFile.createNewFile();
//			FileWriter fileWriter = new FileWriter(outputFile);
//            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
            BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(
                    new FileOutputStream("brew_formula.json"), "utf-8"));
//            JSONArray jsonArr = new JSONArray();
            
           bufferedWriter.write("[");
           bufferedWriter.newLine();
			
            for (File curFile: formulaDir.listFiles()) {
            	String fileName = curFile.getName();
//            	System.out.println(fileName);
            	int dotIndex = fileName.lastIndexOf('.');
            	if (!fileName.substring(dotIndex+1).equals("rb")) continue;
            	
            	String packageName = fileName.substring(0, fileName.length()-3); // get rid of ".rb"
            	
            	JSONObject jsonObject = new JSONObject();
            	jsonObject.put("name", packageName);
            	
    			// read data from doc
//    			File curFile = new File(formulaDir, "aircrack-ng.rb");
    			FileReader fr = new FileReader(curFile);
    			BufferedReader bufferedReader = new BufferedReader(fr);
    			
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
    				keys.add(tmp[0]);
    			}
//    			jsonArr.add(jsonObject);
    			
//    			System.out.println(jsonObject.toJSONString());
    			bufferedWriter.write(jsonObject.toJSONString());
    			bufferedWriter.write(",");
    			bufferedWriter.newLine();
    			
    			// close file
    			bufferedReader.close();
    			count++;
            }
            
//			bufferedWriter.write(jsonArr.toJSONString());
            bufferedWriter.write("]");
			

            // close files. 
            bufferedWriter.close();
            
            System.out.println("Done! Total " + count + " files.");
            System.out.println(keys.toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
