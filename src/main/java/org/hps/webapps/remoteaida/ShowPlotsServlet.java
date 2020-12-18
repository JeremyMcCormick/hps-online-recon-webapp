package org.hps.webapps.remoteaida;

import java.io.IOException;
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

import hep.aida.ref.remote.rmi.client.RmiStoreFactory;

public class ShowPlotsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static Logger LOG = Logger.getLogger(ShowPlotsServlet.class.getPackage().getName());
    static {
        LOG.setLevel(Level.ALL);
    }

    static {
        Logger.getLogger("hep.aida.ref.remote").setLevel(Level.ALL);
    }

    private static final String AIDA_OPTIONS_PARAMETER = "options";
    private static final String STORE_TYPE_PARAMETER = "storeType";
    private static final String STORE_NAME_PARAMETER = "storeName";
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

        HttpSession ses = request.getSession();

        String treeBindName =
                this.getServletContext().getInitParameter("hps.online.recon.connection");

        LOG.info("Opening connection to remote tree: " + treeBindName);

        ses.setAttribute(STORE_NAME_PARAMETER, treeBindName);
        ses.setAttribute(STORE_TYPE_PARAMETER, RmiStoreFactory.storeType);

        boolean duplex = DUPLEX_DEFAULT;
        boolean hurry = HURRY_DEFAULT;
        String options = "duplex=\""+duplex+"\",RmiServerName=\"rmi:"+treeBindName+"\",hurry=\""+hurry+"\"";
        ses.setAttribute(AIDA_OPTIONS_PARAMETER, options);
        LOG.info("Options: " + options);

        final RequestDispatcher dispatcher = this.getServletContext().getRequestDispatcher("/show_plots.jsp");
        dispatcher.forward(request, response);
    }
}
