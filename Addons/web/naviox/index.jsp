<%@page import="com.openxava.naviox.model.User"%>
<%Servlets.setCharacterEncoding(request, response);%>

<%@include file="../xava/imports.jsp"%>

<%@page import="org.openxava.web.servlets.Servlets"%>
<%@page import="org.openxava.util.Locales"%>
<%@page import="org.openxava.util.XavaPreferences"%>
<%@page import="org.openxava.web.style.XavaStyle"%>
<%@page import="org.openxava.web.style.Themes"%> 
<%@page import="com.openxava.naviox.util.Organizations"%>
<%@page import="org.openxava.util.Users"%>
<%@page import="com.openxava.naviox.util.NaviOXPreferences"%>
<%@page import="org.openxava.util.Is"%>
<%@page import="org.openxava.jpa.XPersistence"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.*"%>
<%@page import="org.openxava.application.meta.MetaModule"%>

<jsp:useBean id="context" class="org.openxava.controller.ModuleContext" scope="session"/>
<jsp:useBean id="modules" class="com.openxava.naviox.Modules" scope="session"/>

<%
String windowId = context.getWindowId(request);
context.setCurrentWindowId(windowId);	
String app = request.getParameter("application");
String module = context.getCurrentModule(request);
Locales.setCurrent(request);
modules.setCurrent(request.getParameter("application"), request.getParameter("module"));
String oxVersion = org.openxava.controller.ModuleManager.getVersion();
String title = (String) request.getAttribute("naviox.pageTitle");
if (title == null) title = modules.getCurrentModuleDescription(request); 
boolean hasModules = modules.hasModules(request); 		
org.openxava.controller.ModuleManager manager = (org.openxava.controller.ModuleManager) context
		.get(app, module, "manager", "org.openxava.controller.ModuleManager");
manager.setSession(session);
manager.setApplicationName(request.getParameter("application"));
manager.setModuleName(module); // In order to show the correct description in head

boolean isFirstSteps = com.openxava.naviox.Modules.FIRST_STEPS.equals(module);

String numeroItemCarritos="0";
String imagenURL="";
String userName="";

try{
	numeroItemCarritos=context.get(app, module, "aquatic_numeroItemCarrito").toString();
}catch(Exception e){}

List<Object[]> listaBarraIconos=new ArrayList();


try {
String esquemaActual=XPersistence.getPersistenceUnitProperties().get("hibernate.default_schema").toString();
listaBarraIconos = XPersistence.getManager()
		.createNativeQuery("select distinct mdl.name,bar.icono,bar.color_formato_html,bar.orden FROM "+esquemaActual+".oxroles_oxmodules rmod "+
				"INNER JOIN "+esquemaActual+".oxmodules mdl "+
				"ON rmod.modules_name=mdl.name "+
				"INNER JOIN "+esquemaActual+".oxroles rol "+
				"ON rmod.roles_name = rol.name "+
				"INNER JOIN "+esquemaActual+".oxusers_oxroles usrl "+
				"ON usrl.roles_name = rmod.roles_name "+
				"INNER JOIN "+esquemaActual+".oxusers usu "+
				"ON usu.name = usrl.oxusers_name "+
				"INNER JOIN "+esquemaActual+".ui_bar_sup_der bar "+
				"ON bar.id_usuario_barra = usu.name AND bar.modules_name = mdl.name "+
				"WHERE usu.name='"+Users.getCurrent()+"' AND bar.esta_activo='TRUE' ORDER BY bar.orden").getResultList();					

} catch (Exception e) {

}

%>

<!DOCTYPE html>

<head>
	<title><%=title%></title>
	<link href="<%=request.getContextPath()%>/xava/style/layout.css?ox=<%=oxVersion%>" rel="stylesheet" type="text/css">
    <link href="<%=request.getContextPath()%>/xava/style/<%=Themes.getCSS(request)%>?ox=<%=oxVersion%>" rel="stylesheet" type="text/css"> 
	<link rel="stylesheet" href="<%=request.getContextPath()%>/xava/style/materialdesignicons.css?ox=<%=oxVersion%>">
	<script type='text/javascript' src='<%=request.getContextPath()%>/xava/js/dwr-engine.js?ox=<%=oxVersion%>'></script>
	<script type='text/javascript' src='<%=request.getContextPath()%>/dwr/interface/Modules.js?ox=<%=oxVersion%>'></script>
	<script type='text/javascript' src='<%=request.getContextPath()%>/dwr/interface/Folders.js?ox=<%=oxVersion%>'></script>
</head>

<body <%=XavaStyle.getBodyClass(request)%>>
	
	<div id="main"> 
				
		<% if (hasModules) { %>
			<jsp:include page="leftMenu.jsp"/>
		<% } %>
		
		<div class="module-wrapper">
			<div id="module_header">

				<% if (!isFirstSteps) { %>
				<a id="module_header_menu_button" href="javascript:naviox.hideModulesList('<%=request.getParameter("application")%>', '<%=request.getParameter("module")%>')">
					<i class="mdi mdi-menu"></i></a>
				<% } %>	

				<span id="module_title">
					<%
					if (hasModules && !isFirstSteps) {
					%>
					<span id="module_extended_title">
						<%
						String organizationName = modules.getOrganizationName(request);
						if (!Is.emptyString(organizationName)) {
						%> 
						<%=organizationName%> - 
						<%
						}
						%>
						<%=modules.getApplicationLabel(request)%> - 
					<%
					}
					%>
					</span>
					<%String moduleTitle = hasModules?modules.getCurrentModuleLabel():modules.getCurrentModuleDescription(request);%>
					<%=moduleTitle%>
				</span>	
				
			
			
				
				<a href="javascript:naviox.bookmark()" title="<xava:message key='<%=modules.isCurrentBookmarked(request)?"unbookmark_module":"bookmark_module"%>'/>"> 
					<i id="bookmark" class='mdi mdi-star<%=modules.isCurrentBookmarked(request)?"":"-outline"%>'></i> 
				</a>
				<div id="sign_in_out">
				<ul>
					<%
					if (Is.emptyString(NaviOXPreferences.getInstance().getAutologinUser())) {
						userName = Users.getCurrent();
						String currentModule = request.getParameter("module");
						boolean showSignIn = userName == null && !currentModule.equals("SignIn");
						
						if (showSignIn) {
							String selected = "SignIn".equals(currentModule)?"selected":"";
					%>
					<li>
						<a href="<%=request.getContextPath()%>/m/SignIn" class="sign-in <%=selected%>">
								<xava:message key="signin"/>
						</a>
					</li>
					<%
						}
						if (userName != null) {
							String organization = Organizations.getCurrent(request);
							if (organization == null) organization = "";
							if(!listaBarraIconos.isEmpty()){
			   					for(int i=0;i<listaBarraIconos.size();i++){
			   						Object[] datos=listaBarraIconos.get(i);	   						
			   						MetaModule modulo=new  MetaModule();
									modulo.setName(datos[0].toString());
			   					%>
			   					<li>								   
			   						<a href="<%=modules.getModuleURI(request, modulo)%>?init=true" title = "<%=datos[0].toString()%>" class="sign-in"><i class="mdi-x-large mdi-<%=datos[1]%>" style="padding: 0px 10px 10px 0px;color: #<%=datos[2]%>;"></i></a>
								</li>			   								
			   					<% }
			   				}		   					
		   					%>
		   								<li>
						<a href="<%=request.getContextPath()%>/naviox/signOut.jsp?organization=<%=organization%>"
						class="sign-in"><xava:message key="signout" /> (<%=userName%>)
							<i class="mdi-x-large mdi-exit-to-app" style="color: red;position: relative;top: 3px;"></i></a>
						<%
					imagenURL=User.find(userName).getImagenURL();
					imagenURL=(imagenURL==null?"":imagenURL);
					if(imagenURL.indexOf("https://platform-lookaside.fbsbx.com")> -1){
					%> 
					<li>
					<img class="img-facebook border-2 brc-white-tp1 radius-round" src="<%=imagenURL%>">
					</li>
					
					<% }else{ %>
					<li>
						<a href="<%=request.getContextPath()%>/m/MyPersonalData?init=true" title = "Datos Personales" class="sign-in border-2 brc-white-tp1 radius-round"><i class="mdi-x-large mdi-account" style="padding: 0px 10px 10px 0px;color: white;"></i></a>
					</li>					
							<%
						}					
					}
					} 
					%>
					</ul>					
				</div>
			</div>		
			<% if ("SignIn".equals(module)) {  %>
			<jsp:include page='signIn.jsp'/>
			<% } else { %>
			<div id="module"> 	
				<jsp:include page='<%="../xava/module.jsp?application=" + app + "&module=" + module + "&htmlHead=false"%>'/>
			</div> 
			<% } %>
		</div>
		
	</div> 
	
	<%@include file="indexExt.jsp"%>

	<script type='text/javascript' src='<%=request.getContextPath()%>/naviox/js/naviox.js?ox=<%=oxVersion%>'></script> 
	
	<script>
	$(function() {
		naviox.lockSessionMilliseconds = <%=com.openxava.naviox.model.Configuration.getInstance().getLockSessionMilliseconds()%>; 
		naviox.application = "<%=app%>";
		naviox.module = "<%=module%>";
		naviox.locked = <%=context.get(request, "naviox_locked")%>;
		naviox.init();
	});
	</script>
	

</body>
</html>
