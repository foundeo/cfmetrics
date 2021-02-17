<cfparam name="url.threadName" default="">
<cfparam name="url.filter" default="">
<!doctype html>
<html>
<head>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
</head>
<div id="main" class="container">
<cfset mf = CreateObject("java", "java.lang.management.ManagementFactory")>
<cfset threadBean = mf.getThreadMXBean()>
<cfset currentThread = CreateObject("java", "java.lang.Thread").currentThread()>

<cfset threadDump = threadBean.dumpAllThreads(false, false)>
<h1>Thread Snapshot</h1>
<div class="jumbotron">
	<cfoutput>
	<div class="row">
		<div class="col-sm-3 text-right">Current Thread:</div> 
		<div class="col-sm-9"><strong>#currentThread.getName()#</strong></div>
	</div>
	<div class="row">
		<div class="col-sm-3 text-right">Date / Time:</div> 
		<div class="col-sm-9"><strong>#Dateformat(now(), "full")# <small>at</small> #TimeFormat(now(), "full")#</strong></div>
	</div>
	<div class="row">
		<div class="col-sm-3 text-right">Current Thread Count:</div> 
		<div class="col-sm-9"><strong>#threadBean.getThreadCount()#</strong></div>
	</div>
	<div class="row">
		<div class="col-sm-3 text-right">Peak Thread Count:</div> 
		<div class="col-sm-9"><strong>#threadBean.getPeakThreadCount()#</strong></div>
	</div>
	<div class="row">
		<div class="col-sm-3 text-right">Daemon Thread Count:</div> 
		<div class="col-sm-9"><strong>#threadBean.getDaemonThreadCount()#</strong></div>
	</div>
	<div class="row">
		<div class="col-sm-3 text-right">Total Started Thread Count:</div> 
		<div class="col-sm-9"><strong>#threadBean.getTotalStartedThreadCount()#</strong></div>
	</div>
	

	</cfoutput>
</div>
<form method="get">
	<div class="row p-4">
		<cfoutput>
			<input type="text" name="filter" placeholder="eg: file.cfm" class="form-control col-9" value="">
			<button type="submit" class="btn btn-secondary ml-2">Filter</button>
		</cfoutput>
	</div>
</form>
<table class="table table-striped">
	<tr>
		<th>ThreadID</th>
		<th>Name</th>
		<th>In Native Code</th>
		<th>User Time</th>
		<th>Lock Owner</th>
		<th>StackTrace</th>
	</tr>
	<cfoutput>
	<cfloop array="#threadDump#" index="threadInfo">
		<cfif NOT Len(url.threadName) OR threadInfo.getThreadName() IS url.threadName>
		<!--- threadInfo is a java.lang.management.ThreadInfo --->
		<cfset stackTrace = "">
		<cfset cfTrace = "">
		<cfloop array="#threadInfo.getStackTrace()#" index="st">
			<cfset stackTrace = stackTrace & st.toString() & Chr(10)>	
			<cfif ReFindNoCase("\.cf[mc]:", st.ToString())>
				<cfset cfTrace = cfTrace & st.toString() & Chr(10)>
			</cfif>	
		</cfloop>
		
		<cfif len(url.filter) AND NOT reFindNoCase(url.filter, stackTrace)>
			<cfcontinue>
		</cfif>
		
		<tr>
			<td>#threadInfo.getThreadID()#</td>
			<td><a href="threads.cfm?threadName=#URLEncodedFormat(threadInfo.getThreadName())#">#threadInfo.getThreadName()#</a></td>
			<td>#YesNoFormat(threadInfo.isInNative())#</td>
			<td>#threadBean.getThreadUserTime(threadInfo.getThreadID())/1000000#ms</td>
			<td>#threadInfo.getLockOwnerName()#</td>
			<td>
				<cfif Len(cfTrace)>
					<strong><pre class="text-success">#cfTrace#</pre></strong>
				</cfif>
				
				<small><pre>#stackTrace#</pre></small>
			</td>
			
		</tr>
		</cfif>
	</cfloop>
	</cfoutput>
</table>

<footer class="footer">
	<div class="container">
		<div class="row">
			<div class="col-sm-4 text-right">
				<a href="https://foundeo.com/"><img src="https://foundeo.com/images/foundeo.png" alt="foundeo"></a>
			</div>
			<div class="col-sm-8">
				<strong>Built by Foundeo Inc.</strong>
				<div class="text-muted">
					A CFML Products &amp; Services Company.
					<br>
					<a href="https://foundeo.com/consulting/coldfusion/">ColdFusion Consulting</a> |
					<a href="https://fixinator.app/">Fixinator</a> |
					<a href="https://foundeo.com/hack-my-cf/">HackMyCF</a> |
					<a href="https://foundeo.com/security/fuseguard/">FuseGuard</a>
				</div>
			</div>
		</div>
	</div>
</footer>

</div>
</body>
</html>