<%@page import="org.openxava.util.Users"%>

<%@include file="../xava/imports.jsp"%>
<%@page import="ec.com.quantica.utilerias.ConsultaGenerica"%>
<%@page import="ec.com.quantica.modelo.ConfiguracionesRegistro"%>

<jsp:useBean id="modules" class="com.openxava.naviox.Modules" scope="session"/>
<%
	boolean isFirstSteps = com.openxava.naviox.Modules.FIRST_STEPS.equals(modules.getCurrentModuleName());
	String display = isFirstSteps?"style='display:block'":""; 
String imgSource = "data:image/png;base64,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";
try {
	imgSource = new ConsultaGenerica<ConfiguracionesRegistro>(ConfiguracionesRegistro.class).parametros().getLogo140x40Base64();
} catch (Exception e) {

}	
%>
<div id="modules_list" <%=display%>> 

	<div id="modules_list_top"> 

		<div id="application_title">		
			<div id="application_name">
				<img src="<%=imgSource%>" align="center" alt="<%=modules.getApplicationLabel(request)%>" style="width: 118px; height: 27px;"/>
			</div>
		
			<div id="organization_name">
				<% String organizationName = modules.getOrganizationName(request); %>				
				<%@ include file="organizationNameExt.jsp"%>
			</div>
		
		</div>
		
		<% if (Users.getCurrent() != null && modules.showsIndexLink()) { %>
			 
			<a href="<%=request.getContextPath()%>/m/Index">
				<div id='organizations_index' class='<%="Index".equals(request.getParameter("module"))?"selected":""%>'>	
					<i class="mdi mdi-apps"></i>
					<xava:label key="myOrganizations"/>
				</div>	
			</a>
			
		<% } %>
	
		<jsp:include page="selectModules.jsp">
			<jsp:param name="fixedModules" value="true"/>
		</jsp:include>
		
		
		<jsp:include page="selectModules.jsp">
			<jsp:param name="bookmarkModules" value="true"/>
		</jsp:include>
		
		<% if (modules.showsSearchModules(request)) { %>
		<div id="search_modules">
		<input id="search_modules_text" type="text" size="38" placeholder='<xava:message key="search_modules"/>'/>
		</div>
		<% } %>
		
	</div> 	
							
	<div id="modules_list_outbox">
		<table id="modules_list_box">
			<tr id="modules_list_content">
				<td>
					<jsp:include page="modulesMenu.jsp"/>
				</td>						
			</tr>
		</table>
	</div>

</div>
<% if (!isFirstSteps) { %> 
	<a id="modules_list_hide" href="javascript:naviox.hideModulesList('<%=request.getParameter("application")%>', '<%=request.getParameter("module")%>')">
		<i class="mdi mdi-chevron-left"></i>
	</a>
	
	<a id="modules_list_show" href="javascript:naviox.showModulesList('<%=request.getParameter("application")%>', '<%=request.getParameter("module")%>')">
		<i class="mdi mdi-chevron-right"></i>
	</a>
<% } %>
