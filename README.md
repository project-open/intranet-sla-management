# ]po[ SLA Management
This package is part of ]project-open[, an open-source enterprise project management system.

For more information about ]project-open[ please see:
* [Documentation Wiki](https://www.project-open.com/en/)
* [V5.0 Download](https://sourceforge.net/projects/project-open/files/project-open/V5.0/)
* [Installation Instructions](https://www.project-open.com/en/list-installers)

About ]po[ SLA Management:

<p><p>This &quot;SLA Management&quot; package allows to define and track parameters of service level agreement contracts. It defines the notion of &quot;Service Level Agreement (SLA)&quot;, &quot;SLA Parameter&quot;, &quot;SLA Indicator&quot;, &quot;SLA Service Hours&quot; and &quot;ticket resolution time&quot;. 

# Online Reference Documentation

## Procedure Files

<table cellpadding="0" cellspacing="0"><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/procs-file-view?version_id=1342687&amp;path=packages/intranet-sla-management/tcl/intranet-sla-management-procs.tcl">tcl/intranet-sla-management-procs.tcl</a></b></td><td></td><td></td></tr></table>

## Procedures

<table cellpadding="0" cellspacing="0"><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=callback::im_ticket_after_create::impl::im_sla_management">callback::im_ticket_after_create::impl::im_sla_management</a></b></td><td></td><td>Callback to be executed after the creation of any ticket. </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=callback::im_ticket_after_update::impl::im_sla_management">callback::im_ticket_after_update::impl::im_sla_management</a></b></td><td></td><td>Callback to be executed after the update of any ticket. </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_check_time_in_service_hours">im_sla_check_time_in_service_hours</a></b></td><td></td><td>Returns 1 if the time (example: &quot;09:55&quot;) falls within service hours (example: {09:00 20:00}) </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_day_of_week_list">im_sla_day_of_week_list</a></b></td><td></td><td>Returns a list with weekday names from 0=Su to 6=Sa </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_management_epoch_in_service_hours">im_sla_management_epoch_in_service_hours</a></b></td><td></td><td>Returns 1 if the epoch falls within service hours ToDo:: Implement </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_parameter_component">im_sla_parameter_component</a></b></td><td></td><td>Returns a HTML component to show a list of SLA parameters with the option to add more parameters </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_parameter_list_component">im_sla_parameter_list_component</a></b></td><td></td><td>Returns a HTML component with a mix of SLA parameters and indicators. </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_parameter_permissions">im_sla_parameter_permissions</a></b></td><td></td><td>Fill the &quot;by-reference&quot; variables read, write and admin with the permissions of $user_id on $ticket_id </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_parameter_status_active">im_sla_parameter_status_active</a></b></td><td></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_parameter_status_deleted">im_sla_parameter_status_deleted</a></b></td><td></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_parameter_type_default">im_sla_parameter_type_default</a></b></td><td></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_service_hours_component">im_sla_service_hours_component</a></b></td><td></td><td>Returns a HTML component with a component to display and modify working hours for the 7 days of the week. </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_ticket_close_resolved_tickets_sweeper">im_sla_ticket_close_resolved_tickets_sweeper</a></b></td><td></td><td>Set ticket statatus to &quot;closed&quot; after the ticket is in status &quot;resolved&quot; for a certain time. </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_ticket_solution_time_sweeper">im_sla_ticket_solution_time_sweeper</a></b></td><td></td><td>Calculates &quot;resolution time&quot; for all open tickets. </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_ticket_solution_time_sweeper_helper">im_sla_ticket_solution_time_sweeper_helper</a></b></td><td></td><td>Calculates &quot;resolution time&quot; for all open tickets. </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_sla_ticket_traffic_light_sweeper_helper">im_sla_ticket_traffic_light_sweeper_helper</a></b></td><td></td><td>Calculates the green/yellow/red status of tickets depending on solution time and SLA parameters. </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_ticket_priority_lookup">im_ticket_priority_lookup</a></b></td><td></td><td>Takes ticket_type and ticket_status to lookup the ticket priority in the &quot;map&quot;. </td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/proc-view?version_id=1342687&amp;proc=im_ticket_priority_map_component">im_ticket_priority_map_component</a></b></td><td></td><td>Returns a HTML component with a component containing a list of ticket_type x ticket_severity =&gt; ticket_priority tuples. </td></tr></table>

## SQL Files

<table cellpadding="0" cellspacing="0"><tr valign="top"><td><b><a href="https://www.project-open.net/api-doc/display-sql?package_key=intranet-sla-management&amp;url=postgresql/intranet-sla-management-create.sql&amp;version_id=1342687">sql/postgresql/intranet-sla-management-create.sql</a></b></td><td></td><td></td></tr><tr valign="top"><td><b><a href="https://www.project-open.net/api-doc/display-sql?package_key=intranet-sla-management&amp;url=postgresql/intranet-sla-management-drop.sql&amp;version_id=1342687">sql/postgresql/intranet-sla-management-drop.sql</a></b></td><td></td><td></td></tr></table>

## Content Pages

<table cellpadding="0" cellspacing="0"><tr valign="top"><td><b>www/</b></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/new.adp">new.adp</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/new.tcl">new.tcl</a></b></td><td>Show, create and edit a single SLA parameter</td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/related-objects-associate-2.adp">related-objects-associate-2.adp</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/related-objects-associate-2.tcl">related-objects-associate-2.tcl</a></b></td><td>Associate the ticket_ids in &quot;tid&quot; with one of the specified objects.</td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/related-objects-associate.adp">related-objects-associate.adp</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/related-objects-associate.tcl">related-objects-associate.tcl</a></b></td><td>Allow the user to create new OpenACS relationships.</td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/report-resolution-time-per-support-group.tcl">report-resolution-time-per-support-group.tcl</a></b></td><td>Resolution Time per Support Group This report shows ticket information (resolution time) for the people serving tickets.</td></tr><tr valign="top"><td><b>reports/</b></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/reports/sla-reaction-time.tcl">sla-reaction-time.tcl</a></b></td><td>Show Reaction time per ticket</td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/reports/sla-resolution-time.tcl">sla-resolution-time.tcl</a></b></td><td>Show Resolution time per ticket</td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/service-hours-component.adp">service-hours-component.adp</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/service-hours-component.tcl">service-hours-component.tcl</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/service-hours-save.tcl">service-hours-save.tcl</a></b></td><td>Associate the ticket_ids in &quot;tid&quot; with one of the specified objects.</td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/sla-parameter-action.tcl">sla-parameter-action.tcl</a></b></td><td>Takes commands from the /intranet-sla-management/index page or the sla-parameter-indicator-component and perform the selected action on the selected items</td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/sla-parameter-indicator-component.adp">sla-parameter-indicator-component.adp</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/sla-parameter-indicator-component.tcl">sla-parameter-indicator-component.tcl</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/sla-parameter-list-component.adp">sla-parameter-list-component.adp</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/sla-parameter-list-component.tcl">sla-parameter-list-component.tcl</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/ticket-priority-add.tcl">ticket-priority-add.tcl</a></b></td><td>Add a new tuple to the priority map at the SLA</td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/ticket-priority-component.adp">ticket-priority-component.adp</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/ticket-priority-component.tcl">ticket-priority-component.tcl</a></b></td><td></td></tr><tr valign="top"><td style="width:35%"><b><a href="https://www.project-open.net/api-doc/content-page-view?version_id=1342687&amp;path=packages/intranet-sla-management/www/ticket-priority-del.tcl">ticket-priority-del.tcl</a></b></td><td>Add a new tuple to the priority map at the SLA</td></tr></table>

