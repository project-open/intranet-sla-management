<if @enable_master_p@><master></if>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>
<property name="main_navbar_label">helpdesk</property>
<property name="focus">@focus;literal@</property>
<property name="sub_navbar">@sub_navbar;literal@</property>
<property name="left_navbar">@left_navbar_html;literal@</property>

<SCRIPT Language=JavaScript src=/resources/diagram/diagram/diagram.js></SCRIPT>

<if @message@ not nil>
    <div class="general-message">@message@</div>
</if>

<if @show_components_p@>

    <%= [im_component_bay top] %>
    <table width="100%">
	<tr valign="top">
	<td width="50%">
		<%= [im_box_header [lang::message::lookup "" intranet-sla-management.SAL_Parameter_Details "SLA Parameter Details"]] %>
		<formtemplate id=form></formtemplate>
		@param_action_html;noquote@
		<%= [im_box_footer] %>
		<%= [im_component_bay left] %>
	</td>
	<td width="50%">
		<%= [im_component_bay right] %>
	</td>
	</tr>
    </table>
    <%= [im_component_bay bottom] %>

</if>
<else>

    <%= [im_box_header $page_title] %>
    <formtemplate id="form"></formtemplate>
    <%= [im_box_footer] %>

</else>

