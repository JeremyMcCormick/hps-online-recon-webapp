package org.hps.webapps.remoteaida;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSessionListener;

import hep.aida.IAnalysisFactory;
import hep.aida.ITree;
import hep.aida.ref.remote.rmi.client.RmiStoreFactory;
import hep.aida.web.taglib.util.TreeUtils;

public class TreeSetup extends TreeUtils implements ServletContextListener, HttpSessionListener {
//implements ServletContextListener {

    public TreeSetup() {
    }

    // This works!!! (see logs/catalina.out)
    public void contextInitialized(ServletContextEvent sce) {

        super.contextInitialized(sce);

        //ServletContext ctx = sce.getServletContext();
        System.out.println("Starting up!");
        //try {
        boolean clientDuplex = false;
        boolean hurry = false;
        String treeBindName = "//thinksgiving.localdomain:3001/RmiAidaAgg"; // TODO: read from property
        System.out.println("Connecting to RMI server: " + treeBindName);
        String options = "duplex=\""+clientDuplex+"\",RmiServerName=\"rmi:"+treeBindName+"\",hurry=\""+hurry+"\"";
        IAnalysisFactory af = IAnalysisFactory.create();
        //ITreeFactory tf = af.createTreeFactory();
        ITree tree;
        try {
            //tree = tf.create(treeBindName, RmiStoreFactory.storeType, true, false, options);
            System.out.println("Creating RMI tree: " + treeBindName);
            tree = TreeUtils.getTree(treeBindName, RmiStoreFactory.storeType, options, "FAKE");
            System.out.println("Done creating RMI tree!");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        System.out.println("Remote tree contents...");
        tree.ls("/", true);
        //tree.close();

        //System.out.println("Caching tree...");
        //TreeCache.cache(treeBindName, RmiStoreFactory.storeType, options, "PINNED", true);
        //System.out.println("Done caching tree!");

        //} catch (Exception e) {
        //    e.printStackTrace();
        //}
    }

    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Shutting down!");
        super.contextDestroyed(sce);
    }

}