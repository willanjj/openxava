package org.openxava.util; 

import java.io.*;
import java.util.logging.*;

import org.apache.catalina.startup.*;

/**
 * 
 * @author Javier Paniza
 */
public class AppServer { 
	
	public static void run(String app) throws Exception {
		Logger.getLogger("").setLevel(Level.INFO);
        String webappDir = new File("web").getAbsolutePath();
        Tomcat tomcat = new Tomcat();
        tomcat.setBaseDir("temp"); 
        tomcat.setPort(8080);
        tomcat.getConnector();
        tomcat.enableNaming();          
        tomcat.addWebapp("/" + app, webappDir);
        tomcat.start();

        System.out.println("Application started. Go to http://localhost:8080/" + app); // tmp i18n 
        
        tomcat.getServer().await();
	}

}
