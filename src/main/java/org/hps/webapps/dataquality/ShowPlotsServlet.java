package org.hps.webapps.dataquality;

import java.io.IOException;

import java.util.List;
import java.util.Locale;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.freehep.graphicsbase.util.export.ExportFileType;

import org.freehep.graphicsio.raw.RawImageWriteParam;

public class ShowPlotsServlet extends HttpServlet {

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
    	String file = request.getParameter("file");
        if (file == null) {
            throw new RuntimeException("The file parameter is missing from the request.");
    	}    	
    	request.getSession().setAttribute("file", file);
        String storeType = null;
        if (file.endsWith(".root")) {
            storeType = "root";
        } else if (file.endsWith(".aida")) {
            storeType = "xml";
        } else {
            throw new IllegalArgumentException("File " + file + " has unknown file extension.");
        }
        request.getSession().setAttribute("storeType", storeType);
        final RequestDispatcher dispatcher = this.getServletContext().getRequestDispatcher("/show_plots.jsp");
        dispatcher.forward(request, response);
    }   
}
