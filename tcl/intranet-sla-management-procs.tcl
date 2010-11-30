# /packages/intranet-sla-management/tcl/intranet-sla-management-procs.tcl
#
# Copyright (C) 2003-2007 ]project-open[
#
# All rights reserved. Please check
# http://www.project-open.com/license/ for details.

ad_library {
    @author frank.bergmann@project-open.com
}


# ----------------------------------------------------------------------
# Constants
# ----------------------------------------------------------------------

ad_proc -public im_sla_parameter_status_active {} { return 72000 }
ad_proc -public im_sla_parameter_status_deleted {} { return 72002 }

ad_proc -public im_sla_parameter_type_default {} { return 72100 }


# ----------------------------------------------------------------------
# Permissions
# ---------------------------------------------------------------------

ad_proc -public im_sla_parameter_permissions {
    user_id 
    param_id 
    view_var 
    read_var 
    write_var 
    admin_var
} {
    Fill the "by-reference" variables read, write and admin
    with the permissions of $user_id on $ticket_id
} {
    upvar $view_var view
    upvar $read_var read
    upvar $write_var write
    upvar $admin_var admin

    set view 0
    set read 0
    set write 0
    set admin 0

    # Get the SLA for the parameter.
    # We want to cache the query, so we have to use a "dollar variable" and
    # so we need to check security before doing so...
    im_security_alert_check_integer -location "im_sla_parameter_permissions" -value $param_id
    set sla_id [util_memoize "db_string param_sla {select param_sla_id from im_sla_parameters where param_id = $param_id} -default {}"]

    # Permissions on parameters are permission on the parameter's container project
    im_project_permissions $user_id $sla_id view read write admin
}


# ----------------------------------------------------------------------
# Components
# ---------------------------------------------------------------------

ad_proc -public im_sla_parameter_component {
    -object_id
} {
    Returns a HTML component to show a list of SLA parameters with the option
    to add more parameters
} {
    set project_id $object_id
    if {![im_project_has_type $project_id "Service Level Agreement"]} { 
	ns_log Notice "im_sla_parameter_component: Project \#$project_id is not a 'Service Level Agreement'"
	return "" 
    }

    set params [list \
		    [list base_url "/intranet-sla-management/"] \
		    [list object_id $object_id] \
		    [list return_url [im_url_with_query]] \
    ]

    set result [ad_parse_template -params $params "/packages/intranet-sla-management/www/sla-parameters-list-component"]
    return [string trim $result]
}


ad_proc -public im_sla_parameter_list_component {
    {-project_id ""}
    {-param_id ""}
} {
    Returns a HTML component with a mix of SLA parameters and indicators.
    The component can be used both on the SLAViewPage and the ParamViewPage.
} {
    if {![im_project_has_type $project_id "Service Level Agreement"]} { 
	ns_log Notice "im_sla_parameter_list_component: Project \#$project_id is not a 'Service Level Agreement'"
	return "" 
    }

    set params [list \
		    [list base_url "/intranet-sla-management/"] \
		    [list project_id $project_id] \
		    [list param_id $param_id] \
		    [list return_url [im_url_with_query]] \
    ]

    set result [ad_parse_template -params $params "/packages/intranet-sla-management/www/sla-parameter-indicator-component"]
    return [string trim $result]
}


ad_proc -public im_sla_service_hours_component {
    {-project_id ""}
} {
    Returns a HTML component with a component to display and modify working hours
    for the 7 days of the week.
} {
    if {![im_project_has_type $project_id "Service Level Agreement"]} { 
	ns_log Notice "im_sla_service_hours_component: Project \#$project_id is not a 'Service Level Agreement'"
	return "" 
    }

    set params [list \
		    [list base_url "/intranet-sla-management/"] \
		    [list project_id $project_id] \
		    [list return_url [im_url_with_query]] \
    ]

    set result [ad_parse_template -params $params "/packages/intranet-sla-management/www/service-hours-component"]
    return [string trim $result]
}


ad_proc -public im_sla_day_of_week_list {
} {
    Returns a list with weekday names from 0=Su to 6=Sa
} {
    set dow_list [list]
    lappend dow_list [lang::message::lookup "" intranet-core.Sunday Sunday]
    lappend dow_list [lang::message::lookup "" intranet-core.Monday Monday]
    lappend dow_list [lang::message::lookup "" intranet-core.Tuesday Tuesday]
    lappend dow_list [lang::message::lookup "" intranet-core.Wednesday Wednesday]
    lappend dow_list [lang::message::lookup "" intranet-core.Thursday Thursday]
    lappend dow_list [lang::message::lookup "" intranet-core.Friday Friday]
    lappend dow_list [lang::message::lookup "" intranet-core.Saturday Saturday]
    return $dow_list
}


ad_proc -public im_sla_check_time_in_service_hours {
    time
    service_hours_list
} {
    Returns 1 if the time (example: "09:55") falls within service hours 
    (example: {09:00 20:00})
} {
    foreach tuple $service_hours_list {
	set start [lindex $tuple 0]
	set end   [lindex $tuple 1]
	if {$time >= $start && $time <= $end} { return 1 }
    }
    return 0
}



ad_proc -public im_sla_management_epoch_in_service_hours {
    epoch
    service_hours_list
} {
    Returns 1 if the epoch falls within service hours
    ToDo:: Implement
} {
    return 1
}



# ----------------------------------------------------------------------
# Calculate the Solution time for every ticket
# ---------------------------------------------------------------------

ad_proc -public im_sla_ticket_solution_time {
    {-debug_p 0}
    {-ticket_id ""}
} {
    Calculates "resolution time" for all open tickets.
} {
    # Make sure that only one thread is calculating at a time
#    if {[nsv_incr intranet_sla_management sweeper_p] > 1} {
#        nsv_incr intranet_sla_management sweeper_p -1
#        ns_log Notice "im_sla_ticket_solution_time: Aborting. There is another process running"
#        return
#    }

    # Deal with timezone offsets for epoch calculation...
    set tz_offset_seconds [util_memoize "db_string tz_offset {select extract(timezone from now())}"]

    set debug_html ""
    set time_html ""

    # Returns a list with weekday names from 0=Su, 1=Mo to 6=Sa
    set dow_list [im_sla_day_of_week_list]

    # ----------------------------------------------------------------
    # Get the list of SLAs to work with
    set slas_with_open_tickets [db_list sla_list "
	select	p.project_id
	from	im_projects p
	where	p.project_type_id = [im_project_type_sla] and
		exists (
			select	*
			from	im_tickets t,
				im_projects tp
			where	
				t.ticket_id = tp.project_id and
				tp.parent_id = p.project_id and
				ticket_status_id in ([join [im_sub_categories [im_ticket_status_open]] ","])
		)
    "]

    # ----------------------------------------------------------------
    # Loop through all SLAs

    foreach sla_id $slas_with_open_tickets {

	if {$debug_p} { ns_log Notice "im_sla_ticket_solution_time: sla_id=$sla_id" }

	# ----------------------------------------------------------------
	# Define the service hours per weekday
	#
	set service_hours_sql "
	        select  *
	        from    im_sla_service_hours
	        where   sla_id = :sla_id
		order by dow
	"
	set service_hours_list [list]
	db_foreach service_hours $service_hours_sql {
	    lappend service_hours_list $service_hours
	}

	if {$debug_p} { ns_log Notice "im_sla_ticket_solution_time: sla_id=$sla_id, service_hours=$service_hours_list" }

	# ----------------------------------------------------------------
	# Get the list of all selected ticket (either all open ones or one
	# ticket in particular.
	#
	set extra_where "and t.ticket_status_id in ([join [im_sub_categories [im_ticket_status_open]] ","])"
	if {"" != $ticket_id} { 
	    set extra_where "and t.ticket_id = :ticket_id"
	}
	set ticket_sql "
		select	*,
			extract(epoch from t.ticket_creation_date) as ticket_creation_epoch,
			to_char(t.ticket_creation_date, 'J') as ticket_creation_julian,
			to_char(t.ticket_creation_date, 'YYYY') as ticket_creation_year,
			extract(epoch from now()) as now_epoch,
			to_char(now(), 'J') as now_julian
		from	im_tickets t,
			im_projects p
		where
			t.ticket_id = p.project_id
			$extra_where
		order by
			t.ticket_id
	"
    
	db_foreach tickets $ticket_sql {
	    if {$debug_p} {
		append debug_html "
			<li><b>$ticket_id : $project_name</b>
			<li>ticket_creation_date: $ticket_creation_date
			<li>ticket_creation_julian: $ticket_creation_julian
			<li>ticket_creation_epoch: $ticket_creation_epoch
		"
	    }
	    set name($ticket_id) $project_name
	    set start_julian($ticket_id) $ticket_creation_julian
	    set start_epoch($ticket_id) $ticket_creation_epoch
	    set end_julian($ticket_id) $now_julian
	    set epoch_{$ticket_id}([expr $ticket_creation_epoch - 0.03]) "creation"
	    set julian_{$ticket_id}($ticket_creation_julian) "creation"
	    set epoch_{$ticket_id}([expr $now_epoch + 0.03]) "now"
	    set julian_{$ticket_id}($now_julian) "now"
	    
	    if {$debug_p} { append time_html "<li>Ticket: $ticket_id, ticket_creation_epoch=$ticket_creation_epoch" }
	    
	    #	ad_return_complaint 1 "ticket_id=$ticket_id, [array get epoch_{$ticket_id}]"

	    
	    # Loop through all days between start and end and add the start
	    # and end of the business hours this day.
	    if {$debug_p} { append debug_html "<li>Starting to go loop through julian dates from ticket_creation_julian=$ticket_creation_julian to now_julian=$now_julian ([im_date_julian_to_ansi $ticket_creation_julian] to [im_date_julian_to_ansi $now_julian]\n" }
	    for {set j $ticket_creation_julian} {$j < $now_julian} {incr j} {
		
		# Get the service hours per Day Of Week (0=Su, 1=mo, 6=Sa)
		# service_hours are like {09:00 18:00}
		set dow [expr ($j + 1) % 7]
		set service_hours [lindex $service_hours_list $dow]
		if {$debug_p} { append debug_html "<li>Ticket: $ticket_id, julian=$j, ansi=[im_date_julian_to_ansi $j], dow=$dow: [lindex $dow_list $dow], service_hours=$service_hours\n" }
		
		foreach sh $service_hours {
		    if {$debug_p} { append debug_html "<li>Ticket: $ticket_id, julian=$j, ansi=[im_date_julian_to_ansi $j], sh=$sh\n" }
		    
		    # ----------------------------------------------------------------------------------------
		    # Calculate service start	    
		    # Example: service_start = '09:00'. Add 0.01 to avoid overwriting.
		    set service_start [lindex $sh 0]
		    # On weekends there may be no service hours at all...
		    if {"" == $service_start} { continue }
		    set service_start_list [split $service_start ":"]
		    set service_start_hour [string trimleft [lindex $service_start_list 0] "0"]
		    set service_start_minute [string trimleft [lindex $service_start_list 1] "0"]
		    if {"" == $service_start_hour} { set service_start_hour 0 }
		    if {"" == $service_start_minute} { set service_start_minute 0 }
		    set service_start_epoch [expr [im_date_julian_to_epoch $j] + 3600.0*$service_start_hour + 60.0*$service_start_minute + 0.01]
		    set epoch_{$ticket_id}($service_start_epoch) "service_start"
		    if {$debug_p} { 
			ns_log Notice "im_sla_ticket_solution_time: ticket_id=$ticket_id, service_start=$service_start, hour=$service_start_hour, min=$service_start_minute"
			
			set service_start_epoch2 [db_string epoch "select extract(epoch from to_timestamp('$j $service_start', 'J HH24:MM')) + 0.01"]
			ns_log Notice "im_sla_ticket_solution_time: diff=[expr $service_start_epoch - $service_start_epoch2]"
			append debug_html "<li>Start: julian=$j, ansi=[im_date_julian_to_ansi $j], service_start=$service_start, service_start_epoch=$service_start_epoch\n"
		    }
		    
		    
		    # ----------------------------------------------------------------------------------------
		    # Calculate service end
		    # Example: service_end = '18:00'. Add 0.02 to avoid overwriting.
		    set service_end [lindex $sh 1]
		    # On weekends there may be no service hours at all...
		    if {"" == $service_end} { continue }
		    set service_end_list [split $service_end ":"]
		    set service_end_hour [string trimleft [lindex $service_end_list 0] "0"]
		    set service_end_minute [string trimleft [lindex $service_end_list 1] "0"]
		    if {"" == $service_end_hour} { set service_end_hour 0 }
		    if {"" == $service_end_minute} { set service_end_minute 0 }
		    set service_end_epoch [expr [im_date_julian_to_epoch $j] + 3600.0*$service_end_hour + 60.0*$service_end_minute + 0.01]
		    set epoch_{$ticket_id}($service_end_epoch) "service_end"
		    if {$debug_p} { 
			ns_log Notice "im_sla_ticket_solution_time: ticket_id=$ticket_id, service_end=$service_end, hour=$service_end_hour, min=$service_end_minute"
			
			set service_end_epoch2 [db_string epoch "select extract(epoch from to_timestamp('$j $service_end', 'J HH24:MM')) + 0.01"]
			ns_log Notice "im_sla_ticket_solution_time: diff=[expr $service_end_epoch - $service_end_epoch2]"
			append debug_html "<li>End: julian=$j, ansi=[im_date_julian_to_ansi $j], service_end=$service_end, service_end_epoch=$service_end_epoch\n"
		    }		
		}
		
		# End of looping through service hour start-end tuples
	    }
	}

	# ----------------------------------------------------------------
	# Get all audit records for the open tickets.
	#
	set audit_sql "
		select	*,
			a.audit_object_id as ticket_id,
			extract(epoch from a.audit_date) as audit_date_epoch,
			to_char(a.audit_date, 'J') as audit_date_julian,
			im_category_from_id(audit_object_status_id) as audit_object_status
		from	im_audits a
		where	audit_object_id in (
				select	t.ticket_id
				from	im_tickets t
				where	1=1
					$extra_where
			)
		order by
			ticket_id,
			a.audit_date
	"
	db_foreach audit $audit_sql {
	    if {"" == $audit_object_status} { set audit_object_status "NULL" }
	    if {$debug_p} {	append debug_html "
		<li>$ticket_id: $audit_date: $audit_object_status
	    " }
	    set epoch_{$ticket_id}($audit_date_epoch) $audit_object_status_id
	    set julian_{$ticket_id}($audit_date_julian) $audit_object_status_id
	}


	# Loop through all open tickets
	foreach ticket_id [array names name] {
	    
	    set ticket_name $name($ticket_id)
    
	    if {$debug_p} { append time_html "<li><b>$ticket_id : $ticket_name</b>" }

	    # Copy the epoc_12345 hash into "hash" for easier access.
	    array set hash [array get epoch_{$ticket_id}]
	    
	    # Loop through the hash in time order and process the various events.
	    set resolution_seconds 0.000
	    
	    # Lifetime: Set to 1 by "creation" event and set to 0 by "now" event
	    set ticket_lifetime_p 0
	    set ticket_service_hour_p 0
	    set ticket_open_p 0
	    set count_duration_p 0
	    
	    # Counter from last, reset by "creation" event, this is just a default.
	    set last_epoch $start_epoch($ticket_id)
	    
	    # Loop through events per ticket
	    foreach e [lsort [array names hash]] {
		set event_full $hash($e)
		set event [lindex $event_full 0]
		
		# Calculate duration since last event
		set duration_epoch [expr $e - $last_epoch]
		
		# Event can be a ticket_status_id or {creation service_start service_end now}
		switch $event {
		    creation {
			# creation of ticket. Assume that it's open now and that it's created
			# during service hours (otherwise the taximeter will run until the next day...)
			set resolution_seconds 0.000
			set last_epoch $e
			set ticket_lifetime_p 1
			set ticket_service_hour_p [im_sla_management_epoch_in_service_hours $e $service_hours_list]
			set ticket_open_p 1	
		    }
		    service_start {
			
			# Check if we were to count the duration until now
			set count_duration_p [expr $ticket_open_p && $ticket_lifetime_p && $ticket_service_hour_p]
			if {$count_duration_p} {
			    set resolution_seconds [expr $resolution_seconds + $duration_epoch]
			}
			
			# Start counting the time from now on.
			set ticket_service_hour_p 1
		    }
		    service_end {
			# Check if we were to count the duration until now
			set count_duration_p [expr $ticket_open_p && $ticket_lifetime_p && $ticket_service_hour_p]
			if {$count_duration_p} {
			    set resolution_seconds [expr $resolution_seconds + $duration_epoch]
			}
			
			# Don't count time from now on until the next service_start
			set ticket_service_hour_p 0
		    }
		    now {
			# Check if we were to count the duration until now
			set count_duration_p [expr $ticket_open_p && $ticket_lifetime_p && $ticket_service_hour_p]
			if {$count_duration_p} {
			    set resolution_seconds [expr $resolution_seconds + $duration_epoch]
			}
			
			# Current time. Don't count from here into the future...
			set ticket_lifetime_p 0
		    }
		    "" {
			# No event. Should not occur. But then just ignore...
		    }
		    default {
			# We assume a valid ticket_status_id here, otherwise we will skip...
			if {![string is integer $event]} { ns_log Error "im_sla_ticket_solution_time: found invalid integer for ticket_status_id: $event" }
			
			# Check if we were to count the duration until now
			set count_duration_p [expr $ticket_open_p && $ticket_lifetime_p && $ticket_service_hour_p]
			if {$count_duration_p} {
			    set resolution_seconds [expr $resolution_seconds + $duration_epoch]
			}
			
			if {[im_category_is_a $event 30000]} { 
			    # Open status: continue counting...
			    set ticket_open_p 1
			} else {
			    # Not open, so thats closed probably...
			    set ticket_open_p 0
			}
		    }
		}
		
		set color black
		if {!$count_duration_p} { set color red }
		if {$debug_p} {
		    append time_html "<li>
			<font color=$color>
			$e, [im_date_epoch_to_ansi $e] [im_date_epoch_to_time $e], event=$event, 
			duration=$duration_epoch, count_duration_p=$count_duration_p, resolution_seconds=$resolution_seconds
			</font>
                    "
		}
	    
		set last_epoch $e
	    }
	
	    # Update the resolution time of the ticket
	    db_dml update_resolution_time "
		update im_tickets
		set ticket_resolution_time = [expr $resolution_seconds / 3600.0]
		where ticket_id = :ticket_id
	    "

	    if {$debug_p} {
		append time_html "<li><b>$ticket_id : $ticket_name</b>: $resolution_seconds\n"
		append time_html "</ul><ul>\n"
	    }
	}

	# End of looping through one SLA
    }

    # De-block the execution of this procedure for a 2nd thread
    nsv_incr intranet_sla_management sweeper_p -1

    if {$debug_p} {
	ad_return_complaint 1 "
		<ul>$debug_html</ul><br>
		<ul>$time_html</ul><br>
        "
    }

}






