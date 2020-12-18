package org.hps.webapps.remoteaida;

import java.io.IOException;
import java.net.InetAddress;
import java.rmi.Naming;
import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.freehep.graphicsbase.util.export.ExportFileType;
import org.freehep.graphicsio.raw.RawImageWriteParam;

import hep.aida.IAnalysisFactory;
import hep.aida.ITree;
import hep.aida.ITreeFactory;
import hep.aida.ref.remote.rmi.client.RmiStoreFactory;
import hep.aida.ref.remote.rmi.interfaces.RmiServer;
//import hep.aida.web.taglib.util.TreeCache;
import hep.aida.web.taglib.util.TreeUtils;

public class ShowPlotsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final boolean DEBUG = false;

    private static Logger LOG = Logger.getLogger(ShowPlotsServlet.class.getPackage().getName());
    static {
        LOG.setLevel(Level.ALL);
    }
    static {
        Logger.getLogger("hep.aida.ref.remote").setLevel(Level.ALL);
    }

    private static final int DEFAULT_PORT = 2001;
    private static final String DEFAULT_NAME = "RmiAidaServer";
    private static final String DEFAULT_HOST = "localhost";

    private static final String PORT_PARAMETER = "port";
    private static final String AIDA_OPTIONS_PARAMETER = "options";
    private static final String STORE_TYPE_PARAMETER = "storeType";
    private static final String STORE_NAME_PARAMETER = "storeName";
    //private static final String TREE_BIND_NAME_PARAMETER = "treeBindName";
    private static final String HOST_PARAMETER = "host";
    private static final String NAME_PARAMETER = "name";
    private static final boolean DUPLEX_DEFAULT = false;
    private static final boolean HURRY_DEFAULT = false;

    // Hack to make sure gfx export classes are pre-loaded.
    static {
        new RawImageWriteParam(Locale.ENGLISH);
        ExportFileType.setClassLoader(ShowPlotsServlet.class.getClassLoader());
        List<ExportFileType> types = ExportFileType.getExportFileTypes();
        for (ExportFileType eft : types) {
            Class klass = eft.getClass();
        }
    }

    public void doGet(final HttpServletRequest request, final HttpServletResponse response) throws ServletException, IOException {

        int port = DEFAULT_PORT;
        String name = DEFAULT_NAME;
        String host = DEFAULT_HOST;
        if (request.getParameterMap().containsKey(PORT_PARAMETER)) {
            port = Integer.parseInt(request.getParameter(PORT_PARAMETER));
        }
        if (request.getParameterMap().containsKey(NAME_PARAMETER)) {
            name = request.getParameter(NAME_PARAMETER);
        }
        if (request.getParameterMap().containsKey(HOST_PARAMETER)) {
            host = request.getParameter(HOST_PARAMETER);
        }

        HttpSession ses = request.getSession();

        String treeBindName = "//"+host+":"+port+"/"+name;
        //ses.setAttribute(TREE_BIND_NAME_PARAMETER, treeBindName);
        //LOG.info("treeBindName: " + treeBindName);

        ses.setAttribute(STORE_NAME_PARAMETER, treeBindName);

        String storeType = RmiStoreFactory.storeType;
        ses.setAttribute(STORE_TYPE_PARAMETER, storeType);

        boolean duplex = DUPLEX_DEFAULT;
        boolean hurry = HURRY_DEFAULT;
        String options = "duplex=\""+duplex+"\",RmiServerName=\"rmi:"+treeBindName+"\",hurry=\""+hurry+"\"";
        ses.setAttribute(AIDA_OPTIONS_PARAMETER, options);
        LOG.info("options: " + options);

        try {
            LOG.info("Getting tree from cache...");
            ITree tree = TreeUtils.getTree(treeBindName, request.getSession().getId());
            tree.ls("/", true);
            LOG.info("Got tree from cache!");
        } catch (Exception e) {
            LOG.severe("Failed to get tree from cache!");
            e.printStackTrace();
        }

        if (DEBUG) {

            try {
                LOG.info("Testing thinksgiving host lookup...");
                InetAddress addr = InetAddress.getByName("thinksgiving");
                System.out.println("Got host: " + addr.getCanonicalHostName());
                LOG.info("Host lookup of thinksgiving succeeded!");
            } catch (Exception e) {
                LOG.severe("Host lookup of thinksgiving failed!");
            }

            // DEBUG
            try {
                String testTreeBind = "//thinksgiving:3001/RmiAidaAgg";
                System.out.println("Connecting to RMI server: " + treeBindName);
                IAnalysisFactory af = IAnalysisFactory.create();
                ITreeFactory tf = af.createTreeFactory();
                LOG.info("Testing connection to tree: " + testTreeBind);
                ITree tree = tf.create(treeBindName, RmiStoreFactory.storeType, true, false, options);
                LOG.info("Test connection succeeded!");
                System.out.println("Remote tree contents...");
                tree.ls("/", true);
                tree.close();
            } catch (Exception e) {
                LOG.severe("Test connection failed!");
                e.printStackTrace();
            }

            // DEBUG
            System.out.println("Finding RmiServer with Naming lookup...");
            try {
                String lkp = "//thinksgiving:3001/RmiAidaAgg";
                RmiServer server = (RmiServer) Naming.lookup(lkp);
                if (server != null) {
                    System.out.println("Server: " + server.getClass().getCanonicalName());
                    System.out.println("Server bind name: " + server.getBindName());
                }
                System.out.println("Found RmiServer!");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        final RequestDispatcher dispatcher = this.getServletContext().getRequestDispatcher("/show_plots.jsp");
        dispatcher.forward(request, response);
    }
}
