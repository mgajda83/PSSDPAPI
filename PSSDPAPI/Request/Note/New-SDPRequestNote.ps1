Function New-SDPRequestNote
{
	<#
	.SYNOPSIS
		Add new Note to Request

	.PARAMETER RequestId
		Request id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			"note" = @{
				"description" = "Note description"
				"add_to_linked_requests" = $false
				"mark_first_response" = $false
				"notify_technician" = $false
				"show_to_requester" = $false
			}
		}
		$Note = New-SDPRequestNote -RequestId 25602 -InputData $InputData -Verbose

	.NOTES
		Author: Michal Gajda

	.LINK
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/requests/request_note.html#add-request-note
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
			EntityUri = "/api/v3/requests/$RequestId/notes"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($RequestId,"Add note to request id"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.note
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
