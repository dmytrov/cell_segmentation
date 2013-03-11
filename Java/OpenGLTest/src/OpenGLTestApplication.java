
/**
 * History:
 * 		Dmytro Velychko (2013.03.11) - created
 */
public class OpenGLTestApplication
{
  public static void main(String[] args)
  {
	  //System.setProperty("sun.awt.noerasebackground", "true"); // flicker workaroud		
	  //OneTriangleAWT.main_(args); // flicker, fix works fine
	  //OneTriangleSwingGLCanvas.main_(args); // flicker, fix works fine
	  OneTriangleSwingGLJPanel.main_(args); // no flicker
  }
}