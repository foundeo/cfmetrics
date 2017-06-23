<!doctype html>
<html>
<head>
	<link href="https://maxcdn.bootstrapcdn.com/bootswatch/3.3.7/cosmo/bootstrap.min.css" rel="stylesheet" integrity="sha384-h21C2fcDk/eFsW9sC9h0dhokq5pDinLNklTKoxIZRUn3+hvmgQSffLLQ4G4l2eEr" crossorigin="anonymous">
	<style>
		.progress { height:26px; }
		.progress .progress-bar { line-height: 26px; font-size:16px; }
		.footer {
		  position: absolute;
		  bottom: 0;
		  width: 100%;
		  padding-top: 20px;
		  height: 160px;
		  background-color: #f5f5f5;
		}

	</style>
</head>
<body>
<cfset runtime = CreateObject("java","java.lang.Runtime").getRuntime()>
<cfset freeAllocatedMemory = runtime.freeMemory() / 1024 / 1024>
<cfset currentHeapSize = runtime.totalMemory() / 1024 / 1024>
<cfset memoryInUse = currentHeapSize-freeAllocatedMemory>
<cfset maxHeapSize = runtime.maxMemory() / 1024 / 1024>
<cfset percentUsed = round( (memoryInUse / currentHeapSize) * 100 )>
<cfset percentFree = round( (freeAllocatedMemory / currentHeapSize) * 100 )>
<cfset percentAllocated = round( (currentHeapSize / maxHeapSize) * 100 )>

<div class="container">
	<cfoutput>
		<h1>JVM Memory Metrics</h1>
		<div class="jumbotron">
		<div class="row">
			<div class="col-sm-3 text-right">Memory Usage:</div> 
			<div class="col-sm-9"><strong>#round(memoryInUse)#mb #percentUsed#%</strong> <small class="text-muted">of heap memory is in use</small></div>
		</div>
		<div class="row">
			<div class="col-sm-3 text-right">Free Allocated Memory:</div> 
			<div class="col-sm-9"><strong>#round(freeAllocatedMemory)#mb #percentFree#%</strong> <small class="text-muted">of heap memory is allocated but not in use</small></div>
		</div>
		<div class="row">
			<div class="col-sm-3 text-right">Current Heap Size:</div> 
			<div class="col-sm-9"><strong>#round(currentHeapSize)#mb #percentAllocated#%</strong> <small class="text-muted">of heap memory is allocated</small></div>
		</div>

		<div class="row">
			<div class="col-sm-3 text-right">Max Heap Size:</div> 
			<div class="col-sm-9"><strong>#round(maxHeapSize)#mb</strong> <small class="text-muted">is the maximum amount of memory that <cfif structKeyExists(server, "lucee")>Lucee<cfelse>ColdFusion</cfif> can use. </small></div>
		</div>
		</div>
	

		<h2>Current Heap Memory Usage</h2>
		<div class="progress">
		  <div class="progress-bar <cfif percentUsed GT 90>progress-bar-danger<cfelseif percentUsed GT 50>progress-bar-warning<cfelse>progress-bar-info</cfif> text-large" role="progressbar" style="width:#int(percentUsed)#%">
		    #percentUsed#% In Use
		  </div>
		  <div class="progress-bar progress-bar-success text-large" role="progressbar" style="width:#int(100-int(percentUsed))#%">
		    #percentFree#% Free
		  </div>
		</div>

		<h2>Heap Allocation</h2>
		<div class="progress">
		  <div class="progress-bar progress-bar-info" role="progressbar" style="width:#int(percentAllocated)#%">
		    <div class="text-large">#percentAllocated#% Allocated</div>
		  </div>
		</div>
		<div class="text-muted">
			<cfif percentAllocated LT 100>
					The current heap size is #round(currentHeapSize)#mb, however the JVM is configured to allow it to grow to #round(maxHeapSize)#mb.
			<cfelse>
					The current heap size is #round(currentHeapSize)#mb is equal to the max heap size #round(maxHeapSize)#mb. This 
					simply means that the JVM is not going to grow at runtime (which can be good for performance).
			</cfif>
			Even if your server operating system has more memory, it will not go above this configurable limit.
		</div>
	</cfoutput>
	
</div>
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
					<a href="https://foundeo.com/hack-my-cf/">HackMyCF</a> |
					<a href="https://foundeo.com/security/fuseguard/">FuseGuard</a>
				</div>
			</div>
		</div>
	</div>
</footer>
</body>
</html>