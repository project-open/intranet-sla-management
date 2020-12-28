<if @sla_read@>
<form action="/intranet-sla-management/sla-parameter-action" method=GET>
<%= [export_vars -form {return_url}] %>
<table>
@header_html;noquote@
@body_html;noquote@
</table>
</form>
@footer_html;noquote@
</if>
