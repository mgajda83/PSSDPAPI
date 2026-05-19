Function New-SDPRequestResolution
{
	<#
	.SYNOPSIS
		Add new Task to Request

	.PARAMETER RequestId
		Request id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			"resolution" = @{
				"content" = "Sample resolution"
			}
		}
		$Status = New-SDPRequestResolution -RequestId 25602 -InputData $InputData

	.NOTES
		Author: Michal Gajda
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
	Param (
		[String]$UriSDP,
		[String]$ApiKey,
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
			Method = "POST"
			EntityUri = "/api/v3/requests/$RequestId/resolutions"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($RequestId,"Add note to request id"))
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
