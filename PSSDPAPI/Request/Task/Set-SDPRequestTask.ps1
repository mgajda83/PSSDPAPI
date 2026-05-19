Function Set-SDPRequestTask
{
	<#
	.SYNOPSIS
		Update Request Task

	.PARAMETER TaskId
		Task id

	.PARAMETER RequestId
		Request id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			"task" = @{
				"title" = "New edited task"
				"description" = "Task description!!!"
				"status" = @{
					"id" = "1"
				}
			}
		}
		Set-SDPRequestTask -RequestId 54321 -TaskId 12345 -InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/requests/request_task.html#add-request-task
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Parameter(Mandatory=$true)]
		[Int]$TaskId,
		[Parameter(Mandatory=$true,
			ValueFromPipeline)]
		[Int]$RequestId,
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
			EntityUri = "/api/v3/requests/$RequestId/tasks/$TaskId"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($TaskId,"Update request task by id"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.task
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
