<%@include file="../xava/imports.jsp"%>

<%@page import="org.openxava.application.meta.MetaApplications"%>
<%@page import="org.openxava.application.meta.MetaApplication"%>
<%@page import="org.openxava.util.Locales"%>
<%@page import="org.openxava.web.style.XavaStyle"%>
<%@page import="org.openxava.util.XavaPreferences"%>
<%@page import="org.openxava.jpa.XPersistence"%>
<%
String app = request.getParameter("application");
String imgSource = "data:image/png;base64,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";
	String imgSource1 = "data:image/png;base64,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";
	try {
		imgSource = XPersistence.getManager()
				.createNativeQuery("SELECT logo150x150Base64 FROM public.configuraciones").getSingleResult()
				.toString();
		imgSource1 = XPersistence.getManager()
				.createNativeQuery("SELECT imagen200x300Base64 FROM public.configuraciones").getSingleResult()
				.toString();
	} catch (Exception e) {
	}
	String nombrefc="";
	String linkFoto="";
	try{
		nombrefc=request.getAttribute("fb_name").toString();
		linkFoto=request.getAttribute("fb_picture").toString();				
	} catch (Exception e) {
	}
%>
<div id="imgabajoderecha">
	<img src="<%=imgSource1%>" align="center" />
</div>
<div id="sign_in_box">
	<!-- se anade un logo -->
	<table>
		<tr>
			<td
				style="text-align: center; vertical-align: middle; height: 120px;width: 236px;">
				<img src="<%=imgSource%>" align="center"/>						
			</td>
		</tr>		
	</table>
	<!-- 	Fin -->
	<jsp:include page='<%="../xava/module.jsp?application=" + app + "&module=SignIn"%>'/>
</div>

