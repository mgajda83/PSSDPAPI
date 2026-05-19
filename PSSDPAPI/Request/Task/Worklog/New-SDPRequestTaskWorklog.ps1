Function New-SDPRequestTaskWorklog
{
	<#
	.SYNOPSIS
		Add new Request Task Worklog

	.PARAMETER RequestId
		Request id

	.PARAMETER TaskId
		Task id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			"worklog" = @{
				"description" = "Dodano worklog."
				"include_nonoperational_hours" = $true
				"owner" = @{
					"id" = "381"
				}
				"time_spent" = @{
					"hours" = 0
					"minutes" = 15
				}
			}
		}
		New-SDPRequestTaskWorklog -RequestId 54321 -TaskId 12345 -InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/requests/request_worklog.html#add-request-worklog
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Parameter(Mandatory=$true,
			ValueFromPipeline)]
		[Int]$RequestId,
		[Parameter(Mandatory=$true)]
		[Int]$TaskId,
		[Parameter(Mandatory=$true)]
		$InputData
	)

	Begin
	{
		#Create headers
		if(!$MyInvocation.BoundParameters.ContainsKey("UriSDP"))
		{
			if($Global:UriSDP)
			{
				$UriSDP = $Global:UriSDP
			} else {
				Write-Error "UriSDP parameter is required or run Set-SDPApiConnection first." -ErrorAction Stop
			}
		}
		if(!$MyInvocation.BoundParameters.ContainsKey("ApiKey"))
		{
			if($Global:ApiKey)
			{
				$ApiKey = $Global:ApiKey
			} else {
				Write-Error "ApiKey parameter is required or run Set-SDPApiConnection first." -ErrorAction Stop
			}
		}
	}

	Process
	{
		$InvokeParams = @{
			UriSDP = $UriSDP
			ApiKey = $ApiKey
			Method = "POST"
			EntityUri = "/api/v3/requests/$RequestId/tasks/$TaskId/worklogs"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($TaskId,"Add worklog to request task id"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.worklog
		}

		#Return result
		if($MyInvocation.BoundParameters.ContainsKey("Debug"))
		{
			Return $Result
		} else {
			Return $Results
		}
	}

	End{}
}
