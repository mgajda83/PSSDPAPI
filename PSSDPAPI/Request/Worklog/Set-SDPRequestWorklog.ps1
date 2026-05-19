Function Set-SDPRequestWorklog
{
	<#
	.SYNOPSIS
		Update Request Worklog

	.PARAMETER RequestId
		Request id

	.PARAMETER WorklogId
		Worklog id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			"worklog" = @{
				"description" = "Zrealizowano zgłoszenie."
				"technician" = "6380"
				"workHours" = "0"
				"workMinutes" = "10"
			}
		}
		Set-SDPRequestWorklog -RequestId 54321 -WorklogId 12345 -InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/requests/request_worklog.html#edit-request-worklog
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
		[Int]$WorklogId,
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
			Method = "PUT"
			EntityUri = "/api/v3/requests/$RequestId/worklogs/$WorklogId"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($WorklogId,"Update request worklog by id"))
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
