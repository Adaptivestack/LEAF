package Execution;

import org.testng.annotations.Test;
import org.testng.annotations.BeforeMethod;
import org.testng.AssertJUnit;
import org.testng.asserts.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;

import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.NoSuchElementException;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;

import Framework.TestData;
import Framework.setupFramework;
import Framework.waitMethods;
import Framework.highlightElement;

public class reportBuilderWorkflow extends setupFramework {

	//private static final DateFormat Calendar = null;
	Date date = new Date();
	
	@BeforeMethod
	@BeforeClass
	public void setUp()  {
		if(driver!= null) {
			driver=getDriver();   //   Also have a valid ChromeDriver here
			//System.out.println("Driver established for: " + driver.getClass());
			//driver.manage().timeouts().wait(Framework.waitMethods.w100);
		}
	}
	

	//Cert test in the event this is starting page for tests
	@Test(priority = 1) //MUST REMAIN #1 ( or zero)
	private void testForCertPage() /*throws InterruptedException */ {
	    try {
	    	//waitMethods.implicitWait(waitMethods.w300);
	    	waitMethods.waiter(waitMethods.w300);
	    	WebElement ele = driver.findElement(By.id("details-button"));  //.click();
	    	highlightElement.highLightElement(driver, ele);
	    	ele.click();

	    	waitMethods.waiter(waitMethods.w300);
	    	
	        WebElement ele2 = driver.findElement(By.partialLinkText("Proceed to localhost")); //.click();
	    	ele2.click();
	        System.out.println("Certificate not found, proceeding to unsecure site");
	    } catch (NoSuchElementException e) {
	        System.out.println("Certificate present, proceeding ");
	    } 
	} 
 
// Report Builder Workflow
	
	@Test(priority = 102) //
	private void clickReportBuilder() {
		waitMethods.waiter(waitMethods.w250);       
		WebElement ele = driver.findElement(By.xpath("//*[text()='Report Builder']"));
		// Alternatively:  WebElement ele = driver.findElement(By.xpath("//*[@id=\"bodyarea\"]/div[1]/a[4]/span"));
    	highlightElement.highLightElement(driver, ele);
   		ele.click();
		waitMethods.waiter(waitMethods.w200);
    	System.out.println("Report Builder clicked from home page");
	}
    	
   
	//First input box HTML
	/*
	 * <input type="text" aria-label="text" id="LeafFormSearch54_widgetMat_0" style="width: 250px">
	//*Second Text box HTML
	 * 
	 * First XPath
	 * //*[@id="LeafFormSearch54_widgetMat_0"]  //Nope, can't use
	 * 
	 * First full xpath - YES
	 * /html/body/div[2]/div/div/div[1]/div[2]/div/div[1]/fieldset/table/tr[1]/td[4]/input
	 * 
	 * <input type="text" aria-label="text" id="LeafFormSearch54_widgetMat_1" style="width: 250px">
	 * 
	 */
	 

	
	@Test(priority = 104) //
	private void inputTextBox01() {
		waitMethods.waiter(waitMethods.w250);       
		WebElement ele = driver.findElement(By.xpath("/html/body/div[2]/div/div/div[1]/div[2]/div/div[1]/fieldset/table/tr[1]/td[4]/input"));
    	highlightElement.highLightElement(driver, ele);
    	
    	String name = "test";
   
    	for(int i = 0; i < name.length(); i++) {
    		char c = name.charAt(i);
    		String s = new StringBuilder().append(c).toString();
    		//ele.sendKeys(Keys.chord(name));
    		ele.sendKeys(s);
    		waitMethods.waiter(waitMethods.w200);
    	}
    	
    	System.out.println("Input text to first textbox");			
	}

	
	
//	@Test(priority = 106) //
//	private void methodTitle() {
//		waitMethods.waiter(waitMethods.w250);       
//		WebElement ele = driver.findElement(By.xpath("//*[text()='Report Builder']"));
//		// Alternatively:  WebElement ele = driver.findElement(By.xpath("//*[@id=\"bodyarea\"]/div[1]/a[4]/span"));
//    	highlightElement.highLightElement(driver, ele);
//   		ele.click();
//		waitMethods.waiter(waitMethods.w200);
//    	System.out.println("Report Builder clicked from home page");
//	}

	
//	@Test(priority = 104) //
//	public void verifySearchByEmployee() {         
//		//waitMethods.implicitWait(waitMethods.w300);
//		//waitMethods.waiter(waitMethods.w1k);	
//		WebElement ele = driver.findElement(By.partialLinkText("Wagner")); 
//		//highlightElement.highLightElement(driver, ele);
//		String verify = ele.toString();
//		System.out.println(verify);
//		Assert.assertTrue(ele.toString().contains("Wagner"));
//	
//		waitMethods.waiter(waitMethods.w1k);
//		System.out.println("Search for employee name on page");
//	}


//	@Test(priority = 106) //
//	private void searchByPosition() {
//		waitMethods.waiter(waitMethods.w500);       
//		WebElement ele = driver.findElement(By.id("search"));
//    	//highlightElement.highLightElement(driver, ele);
//    	
//    	String name = "Accountability Officer";
//   
//    	for(int i = 0; i < name.length(); i++) {
//    		char c = name.charAt(i);
//    		String s = new StringBuilder().append(c).toString();
//    		//ele.sendKeys(Keys.chord(name));
//    		ele.sendKeys(s);
//    		waitMethods.waiter(waitMethods.w200);
//    	}
//    	
//    	driver.findElement(By.id("search")).clear();
//    	System.out.println("Search By Position");			
//	}

	
	

	
	
	
	
	
	public String getDate() {
	      String pattern = "MM/dd HH:mm";
	      SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

	      String date = simpleDateFormat.format(new Date());
	      System.out.println(date);
	      
	      return date;
		
		
	}

}  //class
	