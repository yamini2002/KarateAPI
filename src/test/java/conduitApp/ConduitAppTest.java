package conduitApp;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;

import net.masterthought.cucumber.ReportBuilder;

import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.junit.jupiter.api.Test;

import java.io.File;
import net.masterthought.cucumber.Configuration;
import org.apache.commons.io.FileUtils;

class ConduitAppTest {

    // @Test
    // void testParallel() {
    //     Results results = Runner.path("classpath:conduitApp")
    //             .outputCucumberJson(true)
    //             .parallel(1);
    //              generateReport(results.getReportDir());
    //  assertTrue(results.getFailCount() == 0,results.getErrorMessages());
    // //     assertEquals(0, results.getFailCount(), results.getErrorMessages());
    // }

    @Karate.Test
    Karate runAll() {
        return Karate.run().relativeTo(getClass());
    }

    // public static void generateReport(String karateOutputPath) {
    //     Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
    //     List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
    //     jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
    //     Configuration config = new Configuration(new File("target"), "demo");
    //     ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
    //     reportBuilder.generateReports();
    // }

}
