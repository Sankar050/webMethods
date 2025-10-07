

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
// --- <<IS-END-IMPORTS>> ---

public final class resourceMonitoring

{
	// ---( internal utility methods )---

	final static resourceMonitoring _instance = new resourceMonitoring();

	static resourceMonitoring _newInstance() { return new resourceMonitoring(); }

	static resourceMonitoring _cast(Object o) { return (resourceMonitoring)o; }

	// ---( server methods )---




	public static final void getDocName (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(getDocName)>> ---
		// @sigtype java 3.5
		// [i] record:0:required country
		IDataCursor cursor = pipeline.getCursor();
		           
		// Take the input 'country' document
		IData country = IDataUtil.getIData(cursor, "country");
		if (country != null) {
		    IDataCursor cCursor = country.getCursor();
		    if (cCursor.next()) {
		        // First key will be "India"
		        String name = cCursor.getKey();
		        IDataUtil.put(cursor, "countryName", name);
		    }
		    cCursor.destroy();
		}
		// --- <<IS-END>> ---

                
	}
}

