Function Move-SDPRequestToTrash
{
	<#
	.SYNOPSIS
		Remove the request (move to trash)

	.PARAMETER RequestId
		Request id

	.EXAMPLE
		$Request = Move-SDPRequestToTrash -RequestId 547

	.NOTES
		Author: Michal Gajda

	.LINK
		https://ui.servicedeskplus.com/APIDocs3/index.html#delete-request
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
			Method = "DELETE"
			EntityUri = "/api/v3/requests/$RequestId/move_to_trash"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($RequestId,"Move request to trash by"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.request
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
