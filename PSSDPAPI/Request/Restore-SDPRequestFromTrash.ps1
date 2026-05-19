Function Restore-SDPRequestFromTrash
{
	<#
	.SYNOPSIS
		Restore the request from trash

	.PARAMETER Id
		Request id

	.EXAMPLE
		$Request = Restore-SDPRequestFromTrash -Id 547

	.NOTES
		Author: Michal Gajda

	.LINK
		https://ui.servicedeskplus.com/APIDocs3/index.html#restore-request-from-trash
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
		$InvokeParams = @{
			UriSDP = $UriSDP
			ApiKey = $ApiKey
			Method = "PUT"
			EntityUri = "/api/v3/requests/$RequestId/restore_from_trash"
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($TaskId,"Delete request task by id"))
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
