import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class Main{

    public static void main(String[] args) throws IOException {

        int lengthOfTestCase, numberGenerated, currentLength, currentLengthOfEqualValue, currentCredibility,valueToStore;

        Scanner scannerSystemIN = new Scanner(System.in);

        FileWriter printerToFileScenario = new FileWriter("Test Case Scenario.txt");

        FileWriter printerToFileResult = new FileWriter("Test Case Result.txt");

        System.out.println("Enter length of test case: ");

        lengthOfTestCase = scannerSystemIN.nextInt();

        ArrayList<Integer> testCaseScenario = new ArrayList<>();

        ArrayList<Integer> testCaseResult = new ArrayList<>();

        currentLength = 0;

        while(currentLength < lengthOfTestCase){

            currentLengthOfEqualValue = new Random().nextInt(0, lengthOfTestCase) / 10;

            numberGenerated = new Random().nextInt(0, 255);

            for(int i = 0; i <  currentLengthOfEqualValue && currentLength + i < lengthOfTestCase; i = i + 2){

                testCaseScenario.add(i, numberGenerated);

                testCaseScenario.add(i + 1, 0);

            }

            currentLength = currentLength + currentLengthOfEqualValue;

        }

        currentCredibility = 31;

        valueToStore = testCaseScenario.get(0);

        for(int i = 0; i < lengthOfTestCase; i = i + 2){

            if(testCaseScenario.get(i) == 0){

                if(i == 0) currentCredibility = 0;

                testCaseResult.add(i, valueToStore);
                testCaseResult.add(i + 1, currentCredibility);

                if(currentCredibility > 0) currentCredibility--;

            }
            else{

                valueToStore = testCaseScenario.get(i);
                currentCredibility = 31;
                testCaseResult.add(i, valueToStore);
                testCaseResult.add(i + 1, currentCredibility);

            }

        }

        System.out.println(testCaseScenario);

        System.out.println(testCaseResult);

        printerToFileScenario.write("---- Start test case scenario ----");

        for(Integer i : testCaseScenario){

            printerToFileScenario.write(i + ", ");

        }

        printerToFileScenario.write("---- End test case scenario ----");

        printerToFileResult.write("---- Start test case result ----");

        for(Integer i : testCaseResult){

            printerToFileResult.write(i + ", ");

        }

        printerToFileResult.write("---- End test case result ----");

    }

}