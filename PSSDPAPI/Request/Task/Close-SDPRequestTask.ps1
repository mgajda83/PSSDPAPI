Function Close-SDPRequestTask
{
	<#
	.SYNOPSIS
		Close requests task

	.PARAMETER RequestId
		Request id

	.PARAMETER TaskId
		Task id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$Status = Close-SDPRequestTask -RequestId 28559 -TaskId 1436

	.NOTES
		Author: Michal Gajda

	.LINK
		https://ui.servicedeskplus.com/APIDocs3/index.html#close-request
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
		[Int]$TaskId
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
		#Get by ID
		$InvokeParams = @{
			UriSDP = $UriSDP
			ApiKey = $ApiKey
			Method = "PUT"
			EntityUri = "/api/v3/requests/$RequestId/tasks/$TaskId/close"
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($TaskId,"Close task request by id"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.response_status
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
