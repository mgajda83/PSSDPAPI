Function Set-SDPRequestTaskOwner
{
	<#
	.SYNOPSIS
		Assign task request owner

	.PARAMETER RequestId
		Request id

	.PARAMETER TaskId
		Task id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			"task"= @{
				"group" = @{
					"name" = "It"
				}
				"owner"= @{
					"id" = "381"
					"name"= "Gajda Michał"
				}
			}
		}

		$Task = Set-SDPRequestTaskOwner -RequestId 54321 -TaskId 321-InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://ui.servicedeskplus.com/APIDocs3/index.html#assign-request
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low",
		DefaultParameterSetName="Pickup"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Parameter(Mandatory=$true,
			ValueFromPipeline)]
		[Int]$RequestId,
		[Parameter(Mandatory=$true)]
		[Int]$TaskId,
		[Parameter(ParameterSetName="Assign",
			Mandatory=$true)]
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
			EntityUri = "/api/v3/requests/$RequestId/tasks/$TaskId/assign"
			InputData = $InputData
			ContentType = "application/x-www-form-urlencoded"
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($TaskId,"Assign task request owner by id"))
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

Set-Alias -Name Assign-SDPRequestTask -Value Set-SDPRequestTaskOwner
