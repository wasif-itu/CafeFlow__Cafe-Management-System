package listener;

import Util.DBUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;

@WebListener
public class AppContextListener implements ServletContextListener {

  // Called when the webapp starts
  @Override
  public void contextInitialized(ServletContextEvent sce) {
    ServletContext ctx = sce.getServletContext();

    try {
      // OPTION A: Single raw Connection (not recommended for production)
      Connection conn = DBUtil.getConnection();
      ctx.setAttribute("DBConnection", conn);

      // OPTION B (better): a pooled DataSource
      // DataSource ds = DBUtil.getPooledDataSource();
      // ctx.setAttribute("DBDataSource", ds);

      ctx.log("🔌 Database connection initialized and stored in ServletContext");
    } catch (Exception e) {
      ctx.log("❌ Failed to initialize DB connection", e);
      throw new RuntimeException(e);
    }
  }

  // Called when the webapp is shutting down
  @Override
  public void contextDestroyed(ServletContextEvent sce) {
    ServletContext ctx = sce.getServletContext();

    // OPTION A: close the single Connection
    Connection conn = (Connection) ctx.getAttribute("DBConnection");
    if (conn != null) {
      try { conn.close(); ctx.log("🛑 DB connection closed"); }
      catch (Exception ignored) {}
    }

    // OPTION B: if you used a DataSource with a pool, you would shut down the pool here
  }
}
