Function Get-SDPRequestResolution
{
	<#
	.SYNOPSIS
		Get note by id

	.PARAMETER RequestId
		Request id

	.EXAMPLE
		$Resolution = Get-SDPRequestResolution -RequestId 54321

	.NOTES
		Author: Michal Gajda
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
		[Int]$RequestId
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
			Method = "GET"
			EntityUri = "/api/v3/requests/$RequestId/resolutions"
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($RequestId,"Get resolution from request id"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.resolution
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
