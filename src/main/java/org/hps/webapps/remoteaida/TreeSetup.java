package org.hps.webapps.remoteaida;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSessionListener;

import hep.aida.web.taglib.util.TreeUtils;

public class TreeSetup extends TreeUtils implements ServletContextListener, HttpSessionListener {

    public TreeSetup() {
    }

    public void contextInitialized(ServletContextEvent sce) {
        super.contextInitialized(sce);
    }

    public void contextDestroyed(ServletContextEvent sce) {
        super.contextDestroyed(sce);
    }

}